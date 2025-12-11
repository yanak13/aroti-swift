//
//  Date+Formatting.swift
//
//  Date and time formatting utilities for consistent display
//

import Foundation

extension Date {
    /// Format date for display (e.g., "January 15, 1990")
    func formattedBirthDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: self)
    }
    
    /// Format time for display (e.g., "2:30 PM")
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
    
    /// Format date in short format (e.g., "Jan 15, 1990")
    func formattedShortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
}
