//
//  SubscriptionTermsSheet.swift
//  Aroti
//
//  Subscription Terms page
//

import SwiftUI

struct SubscriptionTermsSheet: View {
    var body: some View {
        GlassSheetContainer(title: "Subscription Terms", subtitle: nil) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(subscriptionTermsContent)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .textSelection(.enabled)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var subscriptionTermsContent: String {
        """
        Subscription Terms content will be displayed here.
        
        This section will contain the full subscription terms text including:
        - Auto-renewable subscription details
        - Billing periods and pricing
        - Cancellation policy
        - Refund policy
        - Subscription management instructions
        
        The content will be scrollable and selectable for user convenience.
        """
    }
}
