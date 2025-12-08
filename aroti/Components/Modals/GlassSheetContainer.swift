import SwiftUI

struct GlassSheetContainer<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let subtitle: String?
    let content: () -> Content
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                ScrollView {
                    VStack(spacing: 20) {
                        if let subtitle {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(title)
                                    .font(DesignTypography.title3Font(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                Text(subtitle)
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text(title)
                                .font(DesignTypography.title3Font(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        content()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .preferredColorScheme(.dark)
            .environment(\.colorScheme, .dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(DesignColors.accent)
                }
            }
        }
        .presentationDetents([.large])
    }
}
