//
//  DataDeletionPolicySheet.swift
//  Aroti
//
//  Data Deletion Policy page
//

import SwiftUI

struct DataDeletionPolicySheet: View {
    var body: some View {
        GlassSheetContainer(title: "Data Deletion Policy", subtitle: nil) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(dataDeletionPolicyContent)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .textSelection(.enabled)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var dataDeletionPolicyContent: String {
        """
        Data Deletion Policy content will be displayed here.
        
        This section will explain retention periods and deletion timing.
        
        The content will be scrollable and selectable for user convenience.
        """
    }
}

