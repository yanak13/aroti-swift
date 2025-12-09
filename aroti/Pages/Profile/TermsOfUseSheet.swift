//
//  TermsOfUseSheet.swift
//  Aroti
//
//  Terms of Use page
//

import SwiftUI

struct TermsOfUseSheet: View {
    var body: some View {
        GlassSheetContainer(title: "Terms of Use", subtitle: nil) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(termsOfUseContent)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .textSelection(.enabled)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var termsOfUseContent: String {
        """
        Terms of Use content will be displayed here.
        
        This section will contain the full terms of use text.
        
        The content will be scrollable and selectable for user convenience.
        """
    }
}

