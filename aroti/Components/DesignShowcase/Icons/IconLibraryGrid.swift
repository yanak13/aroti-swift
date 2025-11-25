//
//  IconLibraryGrid.swift
//  Aroti
//

import SwiftUI

struct IconLibraryGrid: View {
    private let icons: [(String, String)] = [
        ("lock", "Lock"), ("calendar", "Calendar"), ("clock", "Clock"),
        ("star", "Star"), ("heart", "Heart"), ("gearshape", "Settings"),
        ("bell", "Bell"), ("globe", "Globe"), ("shield", "Shield"),
        ("pencil", "Pencil"), ("creditcard", "Wallet"), ("doc.text", "FileText"),
        ("arrow.down", "Download"), ("plus", "Plus"), ("checkmark", "Check"),
        ("chevron.right", "ChevronRight"), ("chevron.left", "ChevronLeft"),
        ("arrow.right", "ArrowRight"), ("arrow.left", "ArrowLeft"),
        ("bookmark", "Bookmark"), ("person", "User"), ("house", "Home"),
        ("safari", "Compass"), ("xmark", "X"), ("line.3.horizontal", "Filter"),
        ("magnifyingglass", "Search"), ("video", "Video"), ("message.circle", "MessageCircle"),
        ("crown", "Crown"), ("eye", "Eye"), ("eye.slash", "EyeOff"),
        ("info.circle", "Info"), ("creditcard", "CreditCard"), ("iphone", "Smartphone"),
        ("robot", "Bot"), ("person.2", "Users"), ("sunrise", "Sunrise"),
        ("sun.max", "Sun"), ("sunset", "Sunset"), ("lightbulb", "Lightbulb"),
        ("chart.line.uptrend.xyaxis", "TrendingUp"), ("scalemass", "Scale"),
        ("target", "Target"), ("book", "BookOpen"), ("clock.arrow.circlepath", "History"),
        ("trash", "Trash"), ("ellipsis", "MoreVertical")
    ]
    
    var body: some View {
        DesignCard(title: "Icon Library") {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 16)], spacing: 16) {
                ForEach(icons, id: \.0) { icon in
                    VStack(spacing: 8) {
                        Image(systemName: icon.0)
                            .font(.system(size: 24))
                            .foregroundColor(DesignColors.foreground)
                            .frame(width: 48, height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: DesignRadius.main)
                                    .fill(DesignColors.card.opacity(0.3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignRadius.main)
                                            .stroke(DesignColors.border, lineWidth: 1)
                                    )
                            )
                        
                        Text(icon.1)
                            .font(DesignTypography.caption2Font())
                            .foregroundColor(DesignColors.mutedForeground)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
            }
        }
    }
}

