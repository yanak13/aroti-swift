//
//  SpecialistProfileView.swift
//  Aroti
//
//  Specialist detail/profile page
//

import SwiftUI

struct SpecialistProfileView: View {
    let specialist: Specialist
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite: Bool = false
    @State private var showReviews: Bool = false
    @State private var reviews: [Review] = []
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Hero Image Section
                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 0)
                                .fill(ArotiColor.accent.opacity(0.2))
                                .frame(height: 320)
                            
                            // Gradient Overlay
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.8), .black.opacity(0.4)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            
                            // Status Badge (top-right)
                            VStack {
                                HStack {
                                    Spacer()
                                    Badge(
                                        text: specialist.available ? "Available" : "Offline",
                                        backgroundColor: specialist.available ?
                                            Color.green.opacity(0.2) : Color.gray.opacity(0.2),
                                        textColor: specialist.available ?
                                            Color.green.opacity(0.9) : Color.gray.opacity(0.9),
                                        borderColor: specialist.available ?
                                            Color.green.opacity(0.3) : Color.gray.opacity(0.3)
                                    )
                                    .overlay(
                                        HStack(spacing: 4) {
                                            if specialist.available {
                                                Circle()
                                                    .fill(Color.green)
                                                    .frame(width: 6, height: 6)
                                            }
                                        }
                                        .padding(.leading, 8)
                                    )
                                    .padding(.trailing, 16)
                                    .padding(.top, 16)
                                }
                                Spacer()
                            }
                            
                            // Name and Rating (bottom)
                            VStack(alignment: .leading, spacing: 8) {
                                Text(specialist.name)
                                    .font(DesignTypography.title2Font())
                                    .foregroundColor(DesignColors.foreground)
                                
                                HStack {
                                    Text(specialist.specialty)
                                        .font(DesignTypography.subheadFont())
                                        .foregroundColor(DesignColors.foreground.opacity(0.9))
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(ArotiColor.accent)
                                            .font(.system(size: 14))
                                        
                                        Text(String(format: "%.1f", specialist.rating))
                                            .font(DesignTypography.bodyFont(weight: .semibold))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Button(action: { showReviews = true }) {
                                            Text("\(specialist.reviewCount) reviews")
                                                .font(DesignTypography.subheadFont())
                                                .foregroundColor(ArotiColor.accent)
                                                .underline()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                        }
                        
                        // Content Sections
                        VStack(spacing: 24) {
                            // About Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("About \(specialist.name)")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Rectangle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 1)
                                
                                BaseCard {
                                    Text(bioPreview)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.foreground.opacity(0.8))
                                        .lineSpacing(4)
                                }
                            }
                            .padding(.horizontal, DesignSpacing.md)
                            .padding(.top, 24)
                            
                            // Areas of Expertise
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Areas of expertise")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Rectangle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 1)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(specialist.categories, id: \.self) { category in
                                            ArotiChip(
                                                text: category,
                                                variant: .selected
                                            )
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSpacing.md)
                            
                            // Key Summary Card
                            BaseCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    // Rating & Reviews
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(ArotiColor.accent)
                                            .font(.system(size: 16))
                                        
                                        Text(String(format: "%.1f", specialist.rating))
                                            .font(DesignTypography.bodyFont(weight: .semibold))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Button(action: { showReviews = true }) {
                                            Text("\(specialist.reviewCount) reviews")
                                                .font(DesignTypography.subheadFont())
                                                .foregroundColor(ArotiColor.accent)
                                                .underline()
                                        }
                                    }
                                    
                                    // Experience Stats
                                    Text("\(specialist.sessionCount)+ sessions completed • \(specialist.yearsOfPractice) years of experience")
                                        .font(DesignTypography.subheadFont())
                                        .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                                    
                                    // Price & Duration
                                    HStack {
                                        HStack(spacing: 0) {
                                            Text("$\(specialist.price)")
                                                .font(DesignTypography.bodyFont(weight: .semibold))
                                                .foregroundColor(DesignColors.foreground)
                                            Text(" / session")
                                                .font(DesignTypography.subheadFont())
                                                .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                                        }
                                        
                                        Text("·")
                                            .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                                        
                                        Text("60 min")
                                            .font(DesignTypography.subheadFont())
                                            .foregroundColor(DesignColors.foreground)
                                    }
                                    
                                    // Languages
                                    if !specialist.languages.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Languages")
                                                .font(DesignTypography.subheadFont())
                                                .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                                            
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: 8) {
                                                    ForEach(specialist.languages, id: \.self) { lang in
                                                        ArotiChip(
                                                            text: lang,
                                                            variant: .neutral
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSpacing.md)
                            
                            // Client Experiences (Reviews)
                            VStack(alignment: .leading, spacing: 16) {
                                BaseSectionHeader(
                                    title: "Client experiences",
                                    subtitle: "What others are saying"
                                )
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(reviews) { review in
                                            ReviewCard(review: review)
                                                .frame(width: UIScreen.main.bounds.width - 64)
                                        }
                                    }
                                    .padding(.horizontal, DesignSpacing.md)
                                }
                            }
                            .padding(.top, 8)
                            
                            // You Might Also Like
                            VStack(alignment: .leading, spacing: 16) {
                                BaseSectionHeader(
                                    title: "You Might Also Like",
                                    subtitle: "Similar specialists"
                                )
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(relatedSpecialists.prefix(3)) { related in
                                            RelatedSpecialistCard(specialist: related) {
                                                navigationPath.append(BookingDestination.specialist(related))
                                            }
                                        }
                                    }
                                    .padding(.horizontal, DesignSpacing.md)
                                }
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 120) // Space for sticky bottom bar
                        }
                    }
                }
                
                // Sticky Bottom Bar
                VStack {
                    Spacer()
                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Book a session with \(specialist.name)")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("$\(specialist.price) • 60 min")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 12) {
                            ArotiButton(
                                kind: .custom(.glassCardButton()),
                                title: "Text",
                                action: {
                                    // Navigate to messages
                                }
                            )
                            
                            ArotiButton(
                                kind: .custom(.accentCard()),
                                title: "Book session",
                                action: {
                                    navigationPath.append(BookingDestination.schedule(specialist))
                                }
                            )
                        }
                    }
                    .padding(DesignSpacing.md)
                    .background(
                        Rectangle()
                            .fill(Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.92))
                            .background(.ultraThinMaterial)
                    )
                    .overlay(
                        Rectangle()
                            .fill(Color.white.opacity(0.12))
                            .frame(height: 1),
                        alignment: .top
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(DesignColors.foreground.opacity(0.6))
                            .font(.system(size: 20))
                            .frame(width: 40, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                            )
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isFavorite.toggle() }) {
                        Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                            .foregroundColor(isFavorite ? ArotiColor.accent : DesignColors.foreground.opacity(0.6))
                            .font(.system(size: 20))
                    }
                }
            }
            .navigationDestination(for: BookingDestination.self) { destination in
                switch destination {
                case .schedule(let specialist):
                    ScheduleSessionView(specialist: specialist)
                case .specialist(let specialist):
                    SpecialistProfileView(specialist: specialist)
                default:
                    EmptyView()
                }
            }
            .onAppear {
                reviews = BookingDataService.shared.getReviews(for: specialist.id)
            }
            .sheet(isPresented: $showReviews) {
                ReviewsSheet(specialist: specialist, reviews: reviews)
            }
        }
    }
    
    private var bioPreview: String {
        let sentences = specialist.bio.split(separator: ".").map(String.init)
        return sentences.prefix(2).joined(separator: ".") + (sentences.count > 0 ? "." : "")
    }
    
    private var relatedSpecialists: [Specialist] {
        BookingDataService.shared.specialists
            .filter { $0.id != specialist.id }
            .prefix(3)
            .map { $0 }
    }
}

// Review Card Component
struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(review.userName)
                        .font(DesignTypography.headlineFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < review.rating ? "star.fill" : "star")
                                .foregroundColor(index < review.rating ? ArotiColor.accent : ArotiColor.textSecondary.opacity(0.3))
                                .font(.system(size: 12))
                        }
                    }
                    
                    if let date = formatDate(review.date) {
                        Text(date)
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                }
                
                Text(review.comment)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground.opacity(0.8))
                    .lineSpacing(4)
                    .lineLimit(3)
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return nil }
        
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
}

// Related Specialist Card
struct RelatedSpecialistCard: View {
    let specialist: Specialist
    let onTap: () -> Void
    
    var body: some View {
        BaseCard(variant: .interactive, action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    RoundedRectangle(cornerRadius: DesignRadius.secondary)
                        .fill(ArotiColor.accent.opacity(0.2))
                        .frame(width: 64, height: 64)
                        .overlay(
                            Text(specialist.name.prefix(2).uppercased())
                                .font(DesignTypography.title2Font(weight: .semibold))
                                .foregroundColor(ArotiColor.accent)
                        )
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Text("$\(specialist.price)")
                            .font(DesignTypography.bodyFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        Text(" / session")
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                    }
                }
                
                Text(specialist.name)
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                Text(specialist.specialty)
                    .font(DesignTypography.subheadFont())
                    .foregroundColor(DesignColors.mutedForeground)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(ArotiColor.accent)
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.1f", specialist.rating))
                        .font(DesignTypography.bodyFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("\(specialist.reviewCount) reviews")
                        .font(DesignTypography.subheadFont())
                        .foregroundColor(ArotiColor.accent)
                        .underline()
                }
            }
        }
        .frame(width: 220)
    }
}

// Reviews Sheet
struct ReviewsSheet: View {
    let specialist: Specialist
    let reviews: [Review]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(reviews) { review in
                            ReviewCard(review: review)
                                .padding(.horizontal, DesignSpacing.md)
                        }
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Reviews")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

