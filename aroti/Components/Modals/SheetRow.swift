import SwiftUI

struct SheetRow: View {
    let iconName: String
    let label: String
    var iconColor: Color = DesignColors.accent
    var showChevron: Bool = true
    var textColor: Color = DesignColors.foreground
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                )
            
            Text(label)
                .font(DesignTypography.bodyFont(weight: .medium))
                .foregroundColor(textColor)
            
            Spacer()
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}
