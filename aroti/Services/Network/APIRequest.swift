//
//  APIRequest.swift
//  Aroti
//
//  Request configuration and building
//

import Foundation

struct APIRequest {
    let endpoint: APIEndpoint
    let baseURL: String
    let authToken: String?
    
    init(endpoint: APIEndpoint, baseURL: String, authToken: String? = nil) {
        self.endpoint = endpoint
        self.baseURL = baseURL
        self.authToken = authToken
    }
    
    func build() throws -> URLRequest {
        let url = try endpoint.makeURL(baseURL: baseURL)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Set default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add auth token if required and available
        if endpoint.requiresAuth, let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add body for POST/PUT/PATCH
        if let body = endpoint.body, 
           endpoint.method == .post || endpoint.method == .put || endpoint.method == .patch {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                throw APIError.encodingError(error)
            }
        }
        
        return request
    }
}
