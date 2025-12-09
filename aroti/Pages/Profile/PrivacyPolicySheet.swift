//
//  PrivacyPolicySheet.swift
//  Aroti
//
//  Privacy Policy page
//

import SwiftUI

struct PrivacyPolicySheet: View {
    var body: some View {
        GlassSheetContainer(title: "Privacy Policy", subtitle: nil) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(privacyPolicyContent)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .textSelection(.enabled)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var privacyPolicyContent: String {
        """
        Privacy Policy content will be displayed here.
        
        This section will contain the full privacy policy text with support for hyperlinks and rich text formatting.
        
        The content will be scrollable and selectable for user convenience.
        """
    }
}

