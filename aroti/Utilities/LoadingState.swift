//
//  LoadingState.swift
//  Aroti
//
//  Loading state enum for async operations
//

import Foundation

enum LoadingState: Equatable {
    case idle
    case loading
    case loaded
    case error(APIError)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var error: APIError? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
    
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.loaded, .loaded):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
