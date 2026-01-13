//
//  APIEndpoint.swift
//  Aroti
//
//  API endpoint definitions following RESTful conventions
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: Any]? { get }
    var body: Encodable? { get }
    var requiresAuth: Bool { get }
}

extension APIEndpoint {
    var headers: [String: String]? { nil }
    var queryParameters: [String: Any]? { nil }
    var body: Encodable? { nil }
    var requiresAuth: Bool { true }
    
    func makeURL(baseURL: String) throws -> URL {
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        
        // Add query parameters
        if let queryParams = queryParameters, !queryParams.isEmpty {
            urlComponents.queryItems = queryParams.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        return url
    }
}

// MARK: - Booking Endpoints
enum BookingEndpoint: APIEndpoint {
    case getSpecialists
    case getSpecialist(id: String)
    case getSessions
    case getSession(id: String)
    case bookSession(specialistId: String, date: Date, time: String)
    case updateSession(id: String, date: Date?, time: String?)
    case cancelSession(id: String)
    case getReviews(specialistId: String)
    
    var path: String {
        switch self {
        case .getSpecialists:
            return "/api/specialists"
        case .getSpecialist(let id):
            return "/api/specialists/\(id)"
        case .getSessions:
            return "/api/sessions"
        case .getSession(let id):
            return "/api/sessions/\(id)"
        case .bookSession:
            return "/api/sessions"
        case .updateSession(let id, _, _):
            return "/api/sessions/\(id)"
        case .cancelSession(let id):
            return "/api/sessions/\(id)"
        case .getReviews(let specialistId):
            return "/api/reviews/\(specialistId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getSpecialists, .getSpecialist, .getSessions, .getSession, .getReviews:
            return .get
        case .bookSession:
            return .post
        case .updateSession:
            return .put
        case .cancelSession:
            return .delete
        }
    }
    
    var body: Encodable? {
        switch self {
        case .bookSession(let specialistId, let date, let time):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return BookSessionRequest(
                specialistId: specialistId,
                date: formatter.string(from: date),
                time: time
            )
        case .updateSession(_, let date, let time):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var request = UpdateSessionRequest()
            if let date = date {
                request.date = formatter.string(from: date)
            }
            if let time = time {
                request.time = time
            }
            return request
        default:
            return nil
        }
    }
}

// MARK: - Request Models
struct BookSessionRequest: Codable {
    let specialistId: String
    let date: String
    let time: String
}

struct UpdateSessionRequest: Codable {
    var date: String?
    var time: String?
}

// MARK: - Home Endpoints
enum HomeEndpoint: APIEndpoint {
    case getDailyInsights
    case getUserData
    
    var path: String {
        switch self {
        case .getDailyInsights:
            return "/api/daily-insights"
        case .getUserData:
            return "/api/user/profile"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}

// MARK: - Profile Endpoints
enum ProfileEndpoint: APIEndpoint {
    case getProfile
    case updateProfile(name: String?, location: String?)
    case deleteAccount
    
    var path: String {
        switch self {
        case .getProfile, .updateProfile:
            return "/api/user/profile"
        case .deleteAccount:
            return "/api/user/account"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get
        case .updateProfile:
            return .put
        case .deleteAccount:
            return .delete
        }
    }
    
    var body: Encodable? {
        switch self {
        case .updateProfile(let name, let location):
            var request: [String: String] = [:]
            if let name = name {
                request["name"] = name
            }
            if let location = location {
                request["location"] = location
            }
            return UpdateProfileRequest(data: request)
        default:
            return nil
        }
    }
}

struct UpdateProfileRequest: Codable {
    let data: [String: String]
}

// MARK: - Discovery Endpoints
enum DiscoveryEndpoint: APIEndpoint {
    case getArticles
    case getArticle(id: String)
    case getCourses
    case getCourse(id: String)
    case getPractices
    case getPractice(id: String)
    
    var path: String {
        switch self {
        case .getArticles:
            return "/api/articles"
        case .getArticle(let id):
            return "/api/articles/\(id)"
        case .getCourses:
            return "/api/courses"
        case .getCourse(let id):
            return "/api/courses/\(id)"
        case .getPractices:
            return "/api/practices"
        case .getPractice(let id):
            return "/api/practices/\(id)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}

// MARK: - Guidance Endpoints
enum GuidanceEndpoint: APIEndpoint {
    case getGuidance
    case sendMessage(message: String)
    
    var path: String {
        switch self {
        case .getGuidance:
            return "/api/guidance"
        case .sendMessage:
            return "/api/guidance/messages"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getGuidance:
            return .get
        case .sendMessage:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .sendMessage(let message):
            return SendMessageRequest(message: message)
        default:
            return nil
        }
    }
}

struct SendMessageRequest: Codable {
    let message: String
}
