//
//  APIError.swift
//  Aroti
//
//  API error handling types
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, message: String?)
    case decodingError(Error)
    case encodingError(Error)
    case networkError(Error)
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case timeout
    case noData
    case unknown(Error?)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode, let message):
            return message ?? "HTTP error with status code: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized. Please log in again."
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .serverError:
            return "Server error. Please try again later."
        case .timeout:
            return "Request timed out. Please check your connection."
        case .noData:
            return "No data received from server"
        case .unknown(let error):
            return error?.localizedDescription ?? "An unknown error occurred"
        }
    }
    
    var userFriendlyMessage: String {
        switch self {
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .forbidden:
            return "You don't have permission to access this resource."
        case .notFound:
            return "The requested resource was not found."
        case .serverError:
            return "Something went wrong on our end. Please try again in a moment."
        case .timeout:
            return "The request took too long. Please check your internet connection."
        case .networkError:
            return "Unable to connect to the server. Please check your internet connection."
        default:
            return self.errorDescription ?? "An error occurred. Please try again."
        }
    }
}
