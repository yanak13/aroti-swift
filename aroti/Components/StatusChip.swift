//
//  StatusChip.swift
//  Aroti
//
//  Status badge component (uses ArotiChip)
//

import SwiftUI

enum StatusType {
    case confirmed
    case pending
    case completed
}

struct StatusChip: View {
    let status: StatusType
    
    var body: some View {
        ArotiChip(
            text: statusText,
            variant: chipVariant
        )
    }
    
    private var statusText: String {
        switch status {
        case .confirmed: return "Confirmed"
        case .pending: return "Pending"
        case .completed: return "Completed"
        }
    }
    
    private var chipVariant: ChipVariant {
        switch status {
        case .confirmed, .completed:
            return .success
        case .pending:
            return .warning
        }
    }
}

