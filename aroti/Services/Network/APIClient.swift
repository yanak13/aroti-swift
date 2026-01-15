//
//  APIClient.swift
//  Aroti
//
//  Main HTTP client using URLSession
//

import Foundation

class APIClient {
    static let shared = APIClient()
    
    private let session: URLSession
    private let baseURL: String
    private let timeout: TimeInterval
    private var authToken: String?
    
    init(
        baseURL: String = APIConfiguration.baseURL,
        timeout: TimeInterval = APIConfiguration.defaultTimeout
    ) {
        self.baseURL = baseURL
        self.timeout = timeout
        
        // Configure session
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout * 2
        self.session = URLSession(configuration: configuration)
    }
    
    func setAuthToken(_ token: String?) {
        self.authToken = token
    }
    
    // MARK: - Generic Request Method
    
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {
        let apiRequest = APIRequest(
            endpoint: endpoint,
            baseURL: baseURL,
            authToken: authToken
        )
        
        let request = try apiRequest.build()
        
        if APIConfiguration.debugLogging {
            logRequest(request)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            if APIConfiguration.debugLogging {
                logResponse(data: data, response: response)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Handle HTTP status codes
            try validateResponse(httpResponse)
            
            // Decode response
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let decoded = try decoder.decode(T.self, from: data)
                return decoded
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            throw error
        } catch let error as URLError {
            if error.code == .timedOut {
                throw APIError.timeout
            } else {
                throw APIError.networkError(error)
            }
        } catch {
            throw APIError.unknown(error)
        }
    }
    
    // MARK: - Request with Auto Refresh
    
    func requestWithAutoRefresh<T: Decodable>(
        _ endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {
        do {
            // Try refreshing token if needed before request
            try await AuthManager.shared.refreshIfNeeded()
            
            // Make request
            return try await request(endpoint, responseType: responseType)
        } catch APIError.unauthorized {
            // Token might be expired, try refreshing
            do {
                _ = try await AuthManager.shared.refreshToken()
                // Retry original request with new token
                return try await request(endpoint, responseType: responseType)
            } catch {
                // Refresh failed, throw original error
                throw APIError.unauthorized
            }
        }
    }
    
    // MARK: - Request without response body
    
    func request(_ endpoint: APIEndpoint) async throws {
        let apiRequest = APIRequest(
            endpoint: endpoint,
            baseURL: baseURL,
            authToken: authToken
        )
        
        let request = try apiRequest.build()
        
        if APIConfiguration.debugLogging {
            logRequest(request)
        }
        
        do {
            let (_, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            try validateResponse(httpResponse)
        } catch let error as APIError {
            throw error
        } catch let error as URLError {
            if error.code == .timedOut {
                throw APIError.timeout
            } else {
                throw APIError.networkError(error)
            }
        } catch {
            throw APIError.unknown(error)
        }
    }
    
    // MARK: - Response Validation
    
    private func validateResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return // Success
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.httpError(statusCode: response.statusCode, message: nil)
        }
    }
    
    // MARK: - Logging
    
    private func logRequest(_ request: URLRequest) {
        print("🌐 API Request:")
        print("   Method: \(request.httpMethod ?? "N/A")")
        print("   URL: \(request.url?.absoluteString ?? "N/A")")
        if let headers = request.allHTTPHeaderFields {
            print("   Headers: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("   Body: \(bodyString)")
        }
    }
    
    private func logResponse(data: Data, response: URLResponse) {
        if let httpResponse = response as? HTTPURLResponse {
            print("📥 API Response:")
            print("   Status: \(httpResponse.statusCode)")
            if let dataString = String(data: data, encoding: .utf8) {
                print("   Body: \(dataString.prefix(500))")
            }
        }
    }
}
