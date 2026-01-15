# Frontend Communication Guide

## Overview

This document explains how the iOS frontend communicates with the backend API, including authentication, request/response patterns, error handling, and best practices.

## Communication Architecture

```mermaid
graph TB
    subgraph iOS[iOS App]
        View[SwiftUI View]
        Controller[MVVM Controller]
        APIClient[APIClient]
        AuthManager[AuthManager]
        KeycloakAuth[KeycloakAuthService]
        Keychain[Keychain]
        Cache[CacheManager]
    end
    
    subgraph Backend[Backend API]
        Ingress[Ingress]
        FastAPI[FastAPI]
        Auth[JWT Validator]
        CacheBackend[Redis Cache]
        DB[(PostgreSQL)]
    end
    
    subgraph Keycloak[Keycloak]
        AuthServer[OAuth Server]
        JWK[JWK Endpoint]
    end
    
    View --> Controller
    Controller --> APIClient
    Controller --> AuthManager
    APIClient --> AuthManager
    APIClient --> Cache
    APIClient -->|HTTPS| Ingress
    AuthManager --> Keychain
    KeycloakAuth -->|OAuth PKCE| AuthServer
    KeycloakAuth --> AuthManager
    Ingress --> FastAPI
    FastAPI --> Auth
    Auth -->|Validate| JWK
    FastAPI --> CacheBackend
    FastAPI --> DB
```

## Authentication Flow

### Initial Authentication

**Step 1: User Initiates Login**

```swift
// User taps "Sign In" button
await authController.login()
```

**Step 2: PKCE Flow Initiation**

```swift
// KeycloakAuthService generates PKCE parameters
let codeVerifier = generateCodeVerifier()  // Random 32-byte value
let codeChallenge = generateCodeChallenge(verifier: codeVerifier)  // SHA256 hash
let state = UUID().uuidString  // CSRF protection
```

**Step 3: Authorization Request**

The app opens Keycloak authorization URL in `ASWebAuthenticationSession`:

```
https://auth.aroti.com/realms/aroti/protocol/openid-connect/auth?
  client_id=aroti-ios&
  redirect_uri=com.aroti.app://oauth/callback&
  response_type=code&
  scope=openid profile email offline_access&
  code_challenge=<challenge>&
  code_challenge_method=S256&
  state=<state>
```

**Step 4: User Authentication**

- User enters credentials in Keycloak login form
- Keycloak validates credentials
- Keycloak redirects back to app with authorization code

**Step 5: Token Exchange**

```swift
// App exchanges authorization code for tokens
POST https://auth.aroti.com/realms/aroti/protocol/openid-connect/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&
client_id=aroti-ios&
code=<authorization_code>&
redirect_uri=com.aroti.app://oauth/callback&
code_verifier=<code_verifier>
```

**Response**:
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJSUzI1NiIs...",
  "expires_in": 1800,
  "token_type": "Bearer"
}
```

**Step 6: Token Storage**

```swift
// Save tokens to Keychain
let token = AuthToken(
    accessToken: response.accessToken,
    refreshToken: response.refreshToken,
    expiresAt: Date().addingTimeInterval(TimeInterval(response.expiresIn))
)
try AuthManager.shared.saveToken(token)
```

### Token Refresh

**Pre-emptive Refresh** (Before Request):

```swift
// Check if token expires soon
func refreshIfNeeded() async throws {
    guard let token = try getToken() else { return }
    
    if let expiresAt = token.expiresAt {
        let timeUntilExpiry = expiresAt.timeIntervalSinceNow
        if timeUntilExpiry < 300 {  // Less than 5 minutes
            try await refreshToken()
        }
    }
}
```

**Reactive Refresh** (On 401 Error):

```swift
// APIClient automatically refreshes on 401
func requestWithAutoRefresh<T: Decodable>(
    _ endpoint: APIEndpoint,
    responseType: T.Type
) async throws -> T {
    do {
        return try await request(endpoint, responseType: responseType)
    } catch APIError.unauthorized {
        // Token expired, refresh and retry
        try await AuthManager.shared.refreshToken()
        return try await request(endpoint, responseType: responseType)
    }
}
```

**Refresh Token Request**:

```swift
POST https://auth.aroti.com/realms/aroti/protocol/openid-connect/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token&
client_id=aroti-ios&
refresh_token=<refresh_token>
```

## API Request Flow

### Request Structure

**1. Controller Initiates Request**

```swift
class BookingController: BaseController {
    @Published var specialists: [Specialist] = []
    
    func fetchSpecialists() async {
        loadingState = .loading
        do {
            specialists = try await requestWithCache(
                BookingEndpoint.getSpecialists,
                responseType: [Specialist].self
            )
            loadingState = .loaded
        } catch {
            handleError(error)
        }
    }
}
```

**2. BaseController Handles Caching**

```swift
func requestWithCache<T: Decodable>(
    _ endpoint: APIEndpoint,
    responseType: T.Type
) async throws -> T {
    // Check cache first
    if let cached = await getCached(responseType, for: endpoint) {
        return cached
    }
    
    // Make API request with auto-refresh
    let response = try await apiClient.requestWithAutoRefresh(
        endpoint,
        responseType: responseType
    )
    
    // Cache response
    await setCached(response, for: endpoint)
    
    return response
}
```

**3. APIClient Builds Request**

```swift
func request<T: Decodable>(
    _ endpoint: APIEndpoint,
    responseType: T.Type
) async throws -> T {
    // Build URL
    let url = try endpoint.makeURL(baseURL: APIConfiguration.baseURL)
    
    // Create request
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method.rawValue
    
    // Add headers
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    // Add authentication
    if endpoint.requiresAuth {
        if let token = try AuthManager.shared.getToken() {
            request.setValue("Bearer \(token.accessToken)", 
                           forHTTPHeaderField: "Authorization")
        }
    }
    
    // Add body if needed
    if let body = endpoint.body {
        request.httpBody = try JSONEncoder().encode(body)
    }
    
    // Execute request
    let (data, response) = try await URLSession.shared.data(for: request)
    
    // Validate response
    guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.invalidResponse
    }
    
    // Handle errors
    switch httpResponse.statusCode {
    case 401:
        throw APIError.unauthorized
    case 404:
        throw APIError.notFound
    case 500...599:
        throw APIError.serverError(httpResponse.statusCode)
    default:
        break
    }
    
    // Decode response
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(responseType, from: data)
}
```

**4. HTTP Request Sent**

```
GET https://api.aroti.com/api/specialists
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
Content-Type: application/json
Accept: application/json
```

**5. Backend Processing**

1. Ingress receives request
2. Routes to API pod
3. FastAPI extracts JWT token
4. Validates token with Keycloak JWK
5. Checks Redis cache
6. If cache miss, queries PostgreSQL
7. Stores in cache
8. Returns JSON response

**6. Response Handling**

```swift
// Response JSON
[
  {
    "id": "1",
    "name": "Raluca",
    "specialty": "Astrologer",
    "rating": 4.9,
    ...
  }
]

// Decoded to Swift models
let specialists: [Specialist] = try decoder.decode([Specialist].self, from: data)
```

## Endpoint Examples

### GET Request (List Specialists)

**iOS Code**:
```swift
let specialists = try await controller.requestWithCache(
    BookingEndpoint.getSpecialists,
    responseType: [Specialist].self
)
```

**HTTP Request**:
```
GET /api/specialists
Authorization: Bearer <token>
```

**Response**:
```json
[
  {
    "id": "1",
    "name": "Raluca",
    "specialty": "Astrologer",
    "categories": ["Astrology", "Moon Cycles"],
    "country": "Romania",
    "countryFlag": "🇷🇴",
    "rating": 4.9,
    "reviewCount": 128,
    "sessionCount": 150,
    "price": 40,
    "bio": "15 years of holistic practice...",
    "yearsOfPractice": 15,
    "photo": "specialist-1",
    "available": true,
    "languages": ["Romanian", "English"],
    "addedDate": "2024-01-15"
  }
]
```

### POST Request (Book Session)

**iOS Code**:
```swift
let session = try await controller.request(
    BookingEndpoint.bookSession(
        specialistId: "1",
        date: selectedDate,
        time: "14:00"
    ),
    responseType: Session.self
)
```

**HTTP Request**:
```
POST /api/sessions
Authorization: Bearer <token>
Content-Type: application/json

{
  "specialistId": "1",
  "date": "2025-11-05",
  "time": "14:00"
}
```

**Response**:
```json
{
  "id": "s1",
  "specialistId": "1",
  "specialistName": "Raluca",
  "specialistPhoto": "specialist-1",
  "specialty": "Astrologer",
  "date": "2025-11-05",
  "time": "14:00",
  "duration": 50,
  "price": 40,
  "status": "pending",
  "meetingLink": null,
  "preparationNotes": null
}
```

### PUT Request (Update Session)

**iOS Code**:
```swift
let updated = try await controller.request(
    BookingEndpoint.updateSession(
        id: sessionId,
        date: newDate,
        time: newTime
    ),
    responseType: Session.self
)
```

**HTTP Request**:
```
PUT /api/sessions/s1
Authorization: Bearer <token>
Content-Type: application/json

{
  "date": "2025-11-06",
  "time": "15:00"
}
```

## Error Handling

### Error Types

**APIError Enum**:
```swift
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case httpError(Int)
    case unauthorized
    case forbidden
    case notFound
    case serverError(Int)
    case timeout
    case networkError(Error)
}
```

### Error Handling Pattern

**In Controller**:
```swift
func fetchSpecialists() async {
    loadingState = .loading
    do {
        specialists = try await requestWithCache(...)
        loadingState = .loaded
    } catch let error as APIError {
        handleError(error)
        loadingState = .error(error)
    } catch {
        handleError(APIError.networkError(error))
        loadingState = .error(APIError.networkError(error))
    }
}

func handleError(_ error: APIError) {
    self.error = error
    // Log error
    // Show user-friendly message
}
```

### User-Friendly Error Messages

```swift
extension APIError {
    var userFriendlyMessage: String {
        switch self {
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .networkError:
            return "Network error. Please check your connection."
        case .timeout:
            return "Request timed out. Please try again."
        case .serverError:
            return "Server error. Please try again later."
        default:
            return "An error occurred. Please try again."
        }
    }
}
```

## Caching Strategy

### Two-Tier Caching

**1. Memory Cache** (Fastest):
- In-memory dictionary
- LRU eviction
- Size limit: 50MB

**2. Disk Cache** (Persistent):
- File-based storage
- Survives app restarts
- Size limit: 100MB

### Cache Key Generation

```swift
func cacheKey(for endpoint: APIEndpoint) -> String {
    var key = endpoint.path
    if let params = endpoint.queryParameters {
        let sorted = params.sorted { $0.key < $1.key }
        let paramString = sorted.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        key += "?\(paramString)"
    }
    return key
}
```

### Cache TTL

**Default**: 5 minutes

**Per-Endpoint**:
- Specialist list: 30 minutes
- Individual specialist: 1 hour
- User profile: 5 minutes

### Cache Invalidation

**Automatic**:
- TTL expiration
- Size-based eviction (LRU)

**Manual**:
```swift
// Invalidate cache after update
await cacheManager.delete(cacheKey(for: endpoint))
```

## Best Practices

### 1. Always Use Controllers

**Good**:
```swift
@StateObject private var controller = BookingController()

var body: some View {
    List(controller.specialists) { specialist in
        SpecialistRow(specialist: specialist)
    }
    .task {
        await controller.fetchSpecialists()
    }
}
```

**Bad**:
```swift
// Don't call APIClient directly from views
APIClient.shared.request(...)  // ❌
```

### 2. Handle Loading States

```swift
switch controller.loadingState {
case .idle:
    EmptyView()
case .loading:
    ProgressView()
case .loaded:
    ContentView()
case .error(let error):
    ErrorView(error: error)
}
```

### 3. Use Task Modifier for Async

```swift
.task {
    await controller.fetchData()
}
```

### 4. Error Recovery

```swift
if let error = controller.error {
    Button("Retry") {
        Task {
            await controller.fetchData()
        }
    }
}
```

### 5. Token Management

- Always use `requestWithAutoRefresh` for authenticated endpoints
- Let `AuthManager` handle token refresh automatically
- Don't manually check token expiration (handled by `refreshIfNeeded`)

## Testing

### Mock API Responses

```swift
// In tests
class MockAPIClient: APIClientProtocol {
    func request<T: Decodable>(...) async throws -> T {
        // Return mock data
        return mockSpecialist as! T
    }
}
```

### Test Authentication

```swift
func testTokenRefresh() async throws {
    let manager = AuthManager.shared
    let expiredToken = AuthToken(
        accessToken: "expired",
        refreshToken: "refresh",
        expiresAt: Date().addingTimeInterval(-3600)
    )
    try manager.saveToken(expiredToken)
    
    // Should trigger refresh
    let refreshed = try await manager.refreshIfNeeded()
    XCTAssertNotNil(refreshed)
}
```

## Troubleshooting

### Common Issues

**1. 401 Unauthorized**
- Check token expiration
- Verify Keycloak is accessible
- Check token in Authorization header

**2. Network Errors**
- Check internet connection
- Verify API URL is correct
- Check certificate validity (HTTPS)

**3. Decoding Errors**
- Verify response matches model structure
- Check date format (ISO8601)
- Ensure all required fields are present

**4. Cache Issues**
- Clear cache: `CacheManager.shared.clearAll()`
- Check cache size limits
- Verify cache key generation

### Debug Logging

Enable debug logging in `APIConfiguration`:

```swift
static let debugLogging = true
```

This logs:
- Request URL and method
- Request headers
- Response status code
- Response data

## Security Considerations

### Token Storage

- **Keychain**: Encrypted, secure storage
- **Never**: Store tokens in UserDefaults or files
- **Always**: Use Keychain for sensitive data

### HTTPS Only

- All API communication over HTTPS
- Certificate pinning (optional, for extra security)
- No HTTP in production

### PKCE

- Always use PKCE for OAuth flow
- Prevents authorization code interception
- Required for public clients (mobile apps)

### Token Validation

- Backend validates tokens on every request
- Tokens cannot be tampered with (signature verification)
- Expired tokens automatically rejected
