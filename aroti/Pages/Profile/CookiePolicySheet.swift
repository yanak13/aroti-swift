//
//  CookiePolicySheet.swift
//  Aroti
//
//  Cookie Policy page
//

import SwiftUI

struct CookiePolicySheet: View {
    var body: some View {
        GlassSheetContainer(title: "Cookie Policy", subtitle: nil) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(cookiePolicyContent)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .textSelection(.enabled)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var cookiePolicyContent: String {
        """
        Cookie Policy content will be displayed here.
        
        This section will contain the full cookie policy text.
        
        The content will be scrollable and selectable for user convenience.
        """
    }
}

