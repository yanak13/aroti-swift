//
//  CoursesListingPage.swift
//  Aroti
//
//  Courses listing page matching React implementation
//

import SwiftUI

struct CourseItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let lessonCount: Int
    let price: Double
    let isLocked: Bool
    let category: String
    let duration: String
}

struct CoursesListingPage: View {
    @Environment(\.dismiss) private var dismiss
    
    let courses: [CourseItem] = [
        CourseItem(id: "1", title: "Tarot Fundamentals", description: "Master the basics of tarot reading and card interpretation", lessonCount: 8, price: 29.99, isLocked: true, category: "Tarot", duration: "2h 30m"),
        CourseItem(id: "2", title: "Advanced Astrology", description: "Deep dive into planetary aspects and chart interpretation", lessonCount: 12, price: 49.99, isLocked: true, category: "Astrology", duration: "4h 15m"),
        CourseItem(id: "3", title: "Numerology Mastery", description: "Learn to calculate and interpret life path numbers", lessonCount: 10, price: 39.99, isLocked: true, category: "Numerology", duration: "3h 20m"),
        CourseItem(id: "4", title: "Daily Spiritual Practices", description: "Rituals and practices for everyday spirituality", lessonCount: 6, price: 24.99, isLocked: true, category: "Meditation", duration: "1h 45m"),
        CourseItem(id: "5", title: "Moon Phase Wisdom", description: "Align your practice with lunar cycles and phases", lessonCount: 7, price: 27.99, isLocked: true, category: "Moon Phases", duration: "2h 10m"),
        CourseItem(id: "6", title: "Crystal Healing Essentials", description: "Learn to use crystals for energy healing and balance", lessonCount: 9, price: 34.99, isLocked: true, category: "Crystals", duration: "2h 45m"),
        CourseItem(id: "7", title: "Chakra Balancing Guide", description: "Master the art of aligning and balancing your energy centers", lessonCount: 11, price: 44.99, isLocked: true, category: "Chakras", duration: "3h 30m"),
        CourseItem(id: "8", title: "Manifestation Mastery", description: "Powerful techniques to manifest your desires and goals", lessonCount: 8, price: 32.99, isLocked: true, category: "Manifestation", duration: "2h 20m"),
        CourseItem(id: "9", title: "Angel Numbers Decoded", description: "Understand the messages from the divine realm", lessonCount: 6, price: 26.99, isLocked: true, category: "Angel Numbers", duration: "1h 50m"),
        CourseItem(id: "10", title: "Past Life Regression", description: "Explore your soul's journey through time and space", lessonCount: 10, price: 42.99, isLocked: true, category: "Spiritual Guides", duration: "3h 15m")
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    BaseHeader(
                        title: "All Courses",
                        subtitle: "Mini courses to deepen your practice",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back to Discovery",
                            action: { dismiss() }
                        ),
                        alignment: .leading,
                        horizontalPadding: 0
                    )
                    .padding(.top, 0)
                    
                    ForEach(courses) { course in
                        NavigationLink(destination: CourseDetailPage(courseId: course.id)) {
                            BaseCard(variant: .interactive, action: {}) {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(alignment: .top, spacing: 8) {
                                            Text(course.title)
                                                .font(DesignTypography.headlineFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                                .lineLimit(1)
                                            
                                            if course.isLocked {
                                                Image(systemName: "lock.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        Text(course.description)
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .lineLimit(2)
                                        
                                        HStack(spacing: 16) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "book.fill")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                Text("\(course.lessonCount) \(course.lessonCount == 1 ? "Lesson" : "Lessons")")
                                                    .font(DesignTypography.caption2Font())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "clock.fill")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                Text(course.duration)
                                                    .font(DesignTypography.caption2Font())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                    VStack(alignment: .trailing, spacing: 8) {
                                        if course.isLocked {
                                            Text("$\(String(format: "%.2f", course.price))")
                                                .font(DesignTypography.caption1Font(weight: .medium))
                                                .foregroundColor(DesignColors.accent)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(
                                                    Capsule()
                                                        .fill(DesignColors.accent.opacity(0.2))
                                                        .overlay(
                                                            Capsule()
                                                                .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                                        )
                                                )
                                        } else {
                                            Text("Owned")
                                                .font(DesignTypography.caption1Font(weight: .medium))
                                                .foregroundColor(DesignColors.accent)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(
                                                    Capsule()
                                                        .fill(DesignColors.accent.opacity(0.1))
                                                        .overlay(
                                                            Capsule()
                                                                .stroke(DesignColors.accent.opacity(0.2), lineWidth: 1)
                                                        )
                                                )
                                        }
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 16))
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .buttonStyle(CardTapButtonStyle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 12)
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

// Placeholder for course detail page
struct CourseDetailPage: View {
    let courseId: String
    
    var body: some View {
        Text("Course Detail: \(courseId)")
            .foregroundColor(DesignColors.foreground)
    }
}

#Preview {
    NavigationStack {
        CoursesListingPage()
    }
}

