//
//  CourseDetailPage.swift
//  Aroti
//
//  Course detail page matching React implementation
//

import SwiftUI

struct Lesson: Identifiable {
    let id: String
    let title: String
    let duration: String
    let isLocked: Bool
    let isCompleted: Bool?
}

struct CourseDetail: Identifiable {
    let id: String
    let title: String
    let description: String
    let lessonCount: Int
    let price: Double
    let isLocked: Bool
    let category: String
    let duration: String
    let progress: Double?
    let lessons: [Lesson]
    let instructor: String?
}

// Mock course data matching React implementation
struct CourseData {
    static let courses: [String: CourseDetail] = [
        "1": CourseDetail(
            id: "1",
            title: "Tarot Fundamentals",
            description: "Master the basics of tarot reading and card interpretation. This comprehensive course covers everything from understanding card meanings to performing your first readings with confidence.",
            lessonCount: 8,
            price: 29.99,
            isLocked: true,
            category: "Tarot",
            duration: "2h 30m",
            progress: 0,
            lessons: [
                Lesson(id: "1-1", title: "Introduction to Tarot", duration: "15 min", isLocked: false, isCompleted: nil),
                Lesson(id: "1-2", title: "Understanding the Major Arcana", duration: "25 min", isLocked: false, isCompleted: nil),
                Lesson(id: "1-3", title: "The Four Suits", duration: "20 min", isLocked: true, isCompleted: nil),
                Lesson(id: "1-4", title: "Card Combinations", duration: "22 min", isLocked: true, isCompleted: nil),
                Lesson(id: "1-5", title: "Basic Spreads", duration: "18 min", isLocked: true, isCompleted: nil),
                Lesson(id: "1-6", title: "Reading Techniques", duration: "20 min", isLocked: true, isCompleted: nil),
                Lesson(id: "1-7", title: "Interpreting Reversals", duration: "18 min", isLocked: true, isCompleted: nil),
                Lesson(id: "1-8", title: "Your First Reading", duration: "32 min", isLocked: true, isCompleted: nil)
            ],
            instructor: nil
        ),
        "2": CourseDetail(
            id: "2",
            title: "Advanced Astrology",
            description: "Deep dive into planetary aspects and chart interpretation. Learn to read complex astrological patterns and understand the deeper meanings in birth charts.",
            lessonCount: 12,
            price: 49.99,
            isLocked: true,
            category: "Astrology",
            duration: "4h 15m",
            progress: 0,
            lessons: [
                Lesson(id: "2-1", title: "Planetary Aspects Explained", duration: "25 min", isLocked: false, isCompleted: nil),
                Lesson(id: "2-2", title: "Understanding Houses", duration: "30 min", isLocked: true, isCompleted: nil),
                Lesson(id: "2-3", title: "Transits and Progressions", duration: "28 min", isLocked: true, isCompleted: nil),
                Lesson(id: "2-4", title: "Synastry Basics", duration: "35 min", isLocked: true, isCompleted: nil),
                Lesson(id: "2-5", title: "Composite Charts", duration: "32 min", isLocked: true, isCompleted: nil),
                Lesson(id: "2-6", title: "Timing Events", duration: "28 min", isLocked: true, isCompleted: nil),
                Lesson(id: "2-7", title: "Lunar Cycles", duration: "25 min", isLocked: true, isCompleted: nil),
                Lesson(id: "2-8", title: "Solar Returns", duration: "30 min", isLocked: true, isCompleted: nil),
                Lesson(id: "2-9", title: "Career Indicators", duration: "28 min", isLocked: true, isCompleted: nil),
                Lesson(id: "2-10", title: "Relationship Patterns", duration: "30 min", isLocked: true, isCompleted: nil),
                Lesson(id: "2-11", title: "Advanced Chart Reading", duration: "35 min", isLocked: true, isCompleted: nil),
                Lesson(id: "2-12", title: "Case Studies", duration: "40 min", isLocked: true, isCompleted: nil)
            ],
            instructor: nil
        ),
        "3": CourseDetail(
            id: "3",
            title: "Numerology Mastery",
            description: "Learn to calculate and interpret life path numbers. Discover how numbers reveal your purpose, challenges, and opportunities.",
            lessonCount: 10,
            price: 39.99,
            isLocked: true,
            category: "Numerology",
            duration: "3h 20m",
            progress: 0,
            lessons: [
                Lesson(id: "3-1", title: "Introduction to Numerology", duration: "18 min", isLocked: false, isCompleted: nil),
                Lesson(id: "3-2", title: "Life Path Number Calculation", duration: "22 min", isLocked: true, isCompleted: nil),
                Lesson(id: "3-3", title: "Expression Number", duration: "20 min", isLocked: true, isCompleted: nil),
                Lesson(id: "3-4", title: "Soul Urge Number", duration: "18 min", isLocked: true, isCompleted: nil),
                Lesson(id: "3-5", title: "Personality Number", duration: "20 min", isLocked: true, isCompleted: nil),
                Lesson(id: "3-6", title: "Birth Day Number", duration: "15 min", isLocked: true, isCompleted: nil),
                Lesson(id: "3-7", title: "Pinnacle Numbers", duration: "25 min", isLocked: true, isCompleted: nil),
                Lesson(id: "3-8", title: "Challenge Numbers", duration: "22 min", isLocked: true, isCompleted: nil),
                Lesson(id: "3-9", title: "Personal Year Cycles", duration: "28 min", isLocked: true, isCompleted: nil),
                Lesson(id: "3-10", title: "Complete Number Analysis", duration: "32 min", isLocked: true, isCompleted: nil)
            ],
            instructor: nil
        )
    ]
}

struct CourseDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    let courseId: String
    
    private var course: CourseDetail? {
        CourseData.courses[courseId]
    }
    
    private var progressPercentage: Int {
        guard let course = course,
              !course.lessons.isEmpty else { return 0 }
        let completed = course.lessons.filter { $0.isCompleted == true }.count
        return Int(round(Double(completed) / Double(course.lessons.count) * 100))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        BaseHeader(
                            title: course?.title ?? "Course",
                            subtitle: course?.category,
                            leftAction: BaseHeader.HeaderAction(
                                icon: Image(systemName: "chevron.left"),
                                label: "Back",
                                action: { dismiss() }
                            )
                        )
                        .padding(.top, max(0, geometry.safeAreaInsets.top - 45))
                        
                        if let course = course {
                            // Content
                            VStack(spacing: 16) {
                                // Hero Section
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text(course.category)
                                            .font(DesignTypography.footnoteFont(weight: .medium))
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
                                        
                                        Text(course.title)
                                            .font(DesignTypography.title1Font(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        JustifiedTextView(
                                            text: course.description,
                                            font: DesignTypography.bodyFont(),
                                            foregroundColor: DesignColors.mutedForeground
                                        )
                                        
                                        Divider()
                                            .background(Color.white.opacity(0.1))
                                        
                                        HStack(spacing: 16) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "book.fill")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                Text("\(course.lessonCount) Lessons")
                                                    .font(DesignTypography.footnoteFont())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "clock.fill")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                Text(course.duration)
                                                    .font(DesignTypography.footnoteFont())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Progress Section (if unlocked)
                                if !course.isLocked {
                                    BaseCard {
                                        VStack(alignment: .leading, spacing: 12) {
                                            HStack {
                                                Text("Progress")
                                                    .font(DesignTypography.footnoteFont())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                
                                                Spacer()
                                                
                                                Text("\(progressPercentage)%")
                                                    .font(DesignTypography.footnoteFont(weight: .medium))
                                                    .foregroundColor(DesignColors.foreground)
                                            }
                                            
                                            GeometryReader { proxy in
                                                ZStack(alignment: .leading) {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(Color.white.opacity(0.1))
                                                        .frame(height: 8)
                                                    
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(
                                                            LinearGradient(
                                                                colors: [DesignColors.accent.opacity(0.6), DesignColors.accent],
                                                                startPoint: .leading,
                                                                endPoint: .trailing
                                                            )
                                                        )
                                                        .frame(width: max(proxy.size.width * CGFloat(progressPercentage) / 100, 0), height: 8)
                                                }
                                            }
                                            .frame(height: 8)
                                            
                                            let completed = course.lessons.filter { $0.isCompleted == true }.count
                                            Text("\(completed) of \(course.lessons.count) lessons completed")
                                                .font(DesignTypography.caption2Font())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.horizontal, DesignSpacing.sm)
                                }
                                
                                // Price/Purchase Section (if locked)
                                if course.isLocked {
                                    BaseCard {
                                        VStack(alignment: .leading, spacing: 16) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Price")
                                                        .font(DesignTypography.footnoteFont())
                                                        .foregroundColor(DesignColors.mutedForeground)
                                                    
                                                    Text("$\(course.price, specifier: "%.2f")")
                                                        .font(DesignTypography.title2Font(weight: .medium))
                                                        .foregroundColor(DesignColors.foreground)
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "lock.fill")
                                                    .font(.system(size: 32))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                            
                                            Button(action: {
                                                // TODO: Navigate to purchase page
                                            }) {
                                                HStack {
                                                    Spacer()
                                                    Text("Purchase Course")
                                                        .font(DesignTypography.subheadFont(weight: .medium))
                                                        .foregroundColor(DesignColors.accent)
                                                    Spacer()
                                                }
                                                .padding()
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(DesignColors.accent.opacity(0.1))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                                        )
                                                )
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.horizontal, DesignSpacing.sm)
                                }
                                
                                // Lessons Section
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("Course Lessons")
                                            .font(DesignTypography.title3Font(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        VStack(spacing: 8) {
                                            ForEach(Array(course.lessons.enumerated()), id: \.element.id) { index, lesson in
                                                LessonRow(
                                                    lesson: lesson,
                                                    index: index,
                                                    onTap: {
                                                        if !lesson.isLocked {
                                                            // TODO: Navigate to lesson page
                                                        }
                                                    }
                                                )
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 60)
                        } else {
                            // Not Found
                            BaseCard {
                                VStack {
                                    Text("This course could not be found.")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                            .padding(.top, 16)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct LessonRow: View {
    let lesson: Lesson
    let index: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            lesson.isCompleted == true
                                ? DesignColors.accent.opacity(0.2)
                                : Color.white.opacity(0.05)
                        )
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(
                                    lesson.isCompleted == true
                                        ? DesignColors.accent.opacity(0.3)
                                        : Color.white.opacity(0.2),
                                    lineWidth: 2
                                )
                        )
                    
                    if lesson.isCompleted == true {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(DesignColors.accent)
                    } else if lesson.isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16))
                            .foregroundColor(DesignColors.mutedForeground)
                    } else {
                        Text("\(index + 1)")
                            .font(DesignTypography.footnoteFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(lesson.isLocked ? DesignColors.mutedForeground : DesignColors.foreground)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.mutedForeground)
                        Text(lesson.duration)
                            .font(DesignTypography.caption2Font())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                }
                
                Spacer()
                
                if !lesson.isLocked && lesson.isCompleted != true {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16))
                        .foregroundColor(DesignColors.mutedForeground)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        lesson.isLocked
                            ? Color.white.opacity(0.05)
                            : lesson.isCompleted == true
                                ? DesignColors.accent.opacity(0.1)
                                : Color.white.opacity(0.05)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                lesson.isLocked
                                    ? Color.white.opacity(0.1)
                                    : lesson.isCompleted == true
                                        ? DesignColors.accent.opacity(0.3)
                                        : Color.white.opacity(0.1),
                                lineWidth: 1
                            )
                    )
            )
            .opacity(lesson.isLocked ? 0.6 : 1.0)
        }
        .disabled(lesson.isLocked)
    }
}

#Preview {
    NavigationStack {
        CourseDetailPage(courseId: "1")
    }
}

