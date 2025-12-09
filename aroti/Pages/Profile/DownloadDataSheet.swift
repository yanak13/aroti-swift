//
//  DownloadDataSheet.swift
//  Aroti
//
//  Download My Data page
//

import SwiftUI

struct DownloadDataSheet: View {
    @State private var isRequested: Bool = false
    @State private var isRequesting: Bool = false
    
    var body: some View {
        GlassSheetContainer(title: "Download My Data", subtitle: "Request a copy of your personal data") {
            VStack(spacing: 20) {
                BaseCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("You can request an export of your astrology, numerology, and account data. Processing may take up to 24–48 hours.")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if isRequested {
                    BaseCard {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.success)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Request received")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                Text("Your data request has been received. We will notify you when it is ready for download.")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                ArotiButton(
                    kind: .primary,
                    title: "Request Data Export",
                    isDisabled: isRequested || isRequesting
                ) {
                    requestDataExport()
                }
            }
        }
    }
    
    private func requestDataExport() {
        isRequesting = true
        
        // TODO: Implement actual API call to request data export
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isRequesting = false
            isRequested = true
        }
    }
}

