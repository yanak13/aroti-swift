//
//  ArticleDetailPage.swift
//  Aroti
//
//  Article detail page matching React implementation
//

import SwiftUI

struct Article: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let tag: String
    let category: String
    let content: String
    let author: String?
    let relatedArticles: [String]
}

// Calculate reading time based on word count
func calculateReadingTime(content: String) -> String {
    let wordsPerMinute = 200
    let words = content.trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: .whitespacesAndNewlines)
        .filter { !$0.isEmpty }
    let minutes = max(1, Int(round(Double(words.count) / Double(wordsPerMinute))))
    return "\(minutes) min read"
}

// Mock article data matching React implementation
struct ArticleData {
    static let articles: [String: Article] = [
        "1": Article(
            id: "1",
            title: "Celtic Cross Reading",
            subtitle: "A comprehensive 10-card spread for deep insights",
            tag: "Daily Pick",
            category: "Tarot",
            content: "The Celtic Cross is one of the most popular and comprehensive tarot spreads, offering deep insights into your current situation and future path. This 10-card layout provides a detailed view of your past, present, and potential future. Whether you're a beginner or an experienced reader, mastering the Celtic Cross can transform your tarot practice and provide profound guidance.\n\nEach card position in the Celtic Cross represents a different aspect of your life. Position 1, placed in the center, represents your current situation—the core issue or question at hand. Position 2, crossing Position 1, shows what's crossing or blocking your path. This could be an obstacle, a challenge, or even a helpful influence depending on the card's nature.\n\nPositions 3-6 form the foundation of the cross and reveal deeper layers of your journey. Position 3 represents the distant past—events or influences that have shaped your current situation. Position 4 shows the recent past, what you've just moved through. Position 5 represents the possible future, while Position 6 shows the near future—what's likely to happen soon.\n\nThe staff, formed by Positions 7-10, provides additional context and guidance. Position 7 represents your approach—how you're handling the situation or what attitude you're bringing. Position 8 shows external influences—people, events, or circumstances affecting you. Position 9 reveals your hopes and fears—what you're hoping for or worried about. Finally, Position 10 represents the outcome—the potential resolution or direction things are heading.\n\nThe beauty of the Celtic Cross lies in its ability to reveal both internal and external influences. It helps you understand not just what's happening, but why it's happening and what you can do about it. The spread creates a narrative that connects past, present, and future in a meaningful way.\n\nWhen interpreting the Celtic Cross, pay attention to the relationships between cards. Cards that reinforce each other suggest strong influences, while conflicting cards indicate tension or choices to be made. The suit distribution can reveal whether the situation is primarily emotional (Cups), action-oriented (Wands), mental (Swords), or material (Pentacles).\n\nMajor Arcana cards in the spread indicate significant life lessons or karmic influences at play. Multiple Major Arcana cards suggest a period of major transformation or important life changes. Minor Arcana cards provide more specific, day-to-day guidance and practical advice.\n\nTo get the most from this spread, focus on how the cards relate to each other. Look for patterns, conflicts, and harmonies that tell a complete story about your journey. The Celtic Cross doesn't just answer your question—it provides a comprehensive map of your situation, showing you where you've been, where you are, and where you're heading.\n\nRemember that tarot is a tool for reflection and guidance, not a fixed prediction. The cards show potential paths and influences, but you always have the power to shape your destiny through your choices and actions. Use the insights from the Celtic Cross to make informed decisions and navigate your path with greater awareness and clarity.",
            author: nil,
            relatedArticles: ["7", "8", "5"]
        ),
        "2": Article(
            id: "2",
            title: "Love & Relationships",
            subtitle: "Explore connections and understand dynamics",
            tag: "Recommended",
            category: "Astrology",
            content: "Understanding relationship dynamics through astrology can transform how you connect with others. Your birth chart reveals not just your romantic compatibility, but also your communication style, emotional needs, and partnership patterns. Astrology provides a unique lens through which to understand the complex dance of human connection.\n\nVenus, the planet of love, shows what you value in relationships and how you express affection. When Venus is in fire signs (Aries, Leo, Sagittarius), you express love through passion, excitement, and grand gestures. Earth sign Venus (Taurus, Virgo, Capricorn) values stability, loyalty, and practical demonstrations of care. Air sign Venus (Gemini, Libra, Aquarius) needs intellectual connection and communication. Water sign Venus (Cancer, Scorpio, Pisces) seeks deep emotional intimacy and soul-level bonding.",
            author: nil,
            relatedArticles: ["4", "6", "1"]
        ),
        "3": Article(
            id: "3",
            title: "Moon Phase Meditation",
            subtitle: "Align with lunar cycles for inner peace",
            tag: "Trending",
            category: "Moon Phases",
            content: "Aligning your meditation practice with moon phases creates a powerful rhythm that connects you to natural cycles. Each phase offers unique energy for different types of reflection and growth. The moon has been a guide for spiritual practices for thousands of years, and modern practitioners are rediscovering the profound benefits of lunar alignment.\n\nDuring the New Moon, focus on setting intentions and planting seeds for what you want to manifest. This is a time for quiet reflection and clarity about your desires. The darkness of the new moon represents a blank canvas, perfect for envisioning new beginnings.",
            author: nil,
            relatedArticles: ["5", "8", "1"]
        ),
        "4": Article(
            id: "4",
            title: "Birth Chart Basics",
            subtitle: "Discover your cosmic blueprint",
            tag: "For You",
            category: "Astrology",
            content: "Your birth chart is a snapshot of the sky at the exact moment you were born. It's your cosmic blueprint, revealing your personality, talents, challenges, and life path. Also known as a natal chart, this map of the heavens at your birth moment provides profound insights into who you are and why you're here.\n\nThe Sun sign represents your core identity and ego—who you are at your essence. This is the sign most people know, as it's determined by your birth date.",
            author: nil,
            relatedArticles: ["2", "6", "1"]
        ),
        "5": Article(
            id: "5",
            title: "Numerology Fundamentals",
            subtitle: "Discover the power of numbers in your life",
            tag: "Featured",
            category: "Numerology",
            content: "Numerology is the ancient study of numbers and their mystical significance in our lives. Every number carries a unique vibration and meaning, and by understanding these vibrations, we can gain profound insights into our personality, life path, and destiny.",
            author: nil,
            relatedArticles: ["3", "7", "8"]
        ),
        "6": Article(
            id: "6",
            title: "Understanding Planetary Aspects",
            subtitle: "How planets interact in your birth chart",
            tag: "Advanced",
            category: "Astrology",
            content: "Planetary aspects are the angles formed between planets in your birth chart, and they reveal how different parts of your personality and life experiences interact. Understanding aspects is crucial for reading a birth chart accurately, as they show the dynamic relationships between planetary energies.",
            author: nil,
            relatedArticles: ["2", "4", "1"]
        ),
        "7": Article(
            id: "7",
            title: "Three Card Tarot Spreads",
            subtitle: "Simple yet powerful reading techniques",
            tag: "Beginner",
            category: "Tarot",
            content: "Three-card tarot spreads are among the most versatile and accessible reading techniques, perfect for both beginners and experienced readers. Despite their simplicity, three-card spreads can provide profound insights into any situation.",
            author: nil,
            relatedArticles: ["1", "8", "5"]
        ),
        "8": Article(
            id: "8",
            title: "Chakra Balancing Practices",
            subtitle: "Align your energy centers for wellness",
            tag: "Wellness",
            category: "Meditation",
            content: "Chakras are energy centers in your body that correspond to different aspects of your physical, emotional, and spiritual well-being. There are seven main chakras, each located along your spine from the base to the crown of your head.",
            author: nil,
            relatedArticles: ["3", "5", "1"]
        )
    ]
}

struct ArticleDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    let articleId: String
    @State private var isSaved: Bool = false
    @State private var showUnlockModal = false
    @State private var isUnlocked = false
    
    private var article: Article? {
        ArticleData.articles[articleId]
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            if let article = article {
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        BaseHeader(
                            title: article.title,
                            subtitle: article.category,
                            leftAction: BaseHeader.HeaderAction(
                                icon: Image(systemName: "chevron.left"),
                                label: "Back",
                                action: { dismiss() }
                            ),
                            rightView: AnyView(
                                HStack(spacing: 8) {
                                    Button(action: {
                                        isSaved.toggle()
                                    }) {
                                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                            .font(.system(size: 20))
                                            .foregroundColor(isSaved ? DesignColors.accent : DesignColors.mutedForeground)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.white.opacity(0.05))
                                            )
                                    }
                                    
                                    Button(action: {
                                        // Handle share
                                    }) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 20))
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.white.opacity(0.05))
                                            )
                                    }
                                }
                            ),
                            alignment: .leading,
                            horizontalPadding: 0
                        )
                        .padding(.top, 0)
                        
                        // Hero Section
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(article.tag)
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
                                
                                Text(article.title)
                                    .font(DesignTypography.title2Font(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(article.subtitle)
                                    .font(DesignTypography.subheadFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                
                                Text(calculateReadingTime(content: article.content))
                                    .font(DesignTypography.caption2Font())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                        
                        // Image Placeholder
                        BaseCard {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                                .frame(height: 200)
                                .overlay(
                                    Text(article.category)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                )
                        }
                        
                        // Main Content
                        if isUnlocked || AccessControlService.shared.isPremium {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(Array(article.content.components(separatedBy: "\n\n").enumerated()), id: \.offset) { index, paragraph in
                                    if !paragraph.isEmpty {
                                        FormattedTextView(
                                            text: paragraph,
                                            font: DesignTypography.bodyFont(),
                                            foregroundColor: DesignColors.foreground,
                                            highlightColor: DesignColors.accent
                                        )
                                        .id("paragraph-\(article.id)-\(index)")
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, DesignSpacing.sm)
                            .frame(maxWidth: .infinity)
                        } else {
                            // Preview only
                            BaseCard {
                                VStack(spacing: 16) {
                                    Text(article.content.components(separatedBy: "\n\n").first ?? "")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .lineLimit(3)
                                    
                                    Button(action: {
                                        showUnlockModal = true
                                    }) {
                                        Text("Unlock Full Article - 20 points")
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(DesignColors.accent)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                        }
                        
                        // Related Articles
                        if !article.relatedArticles.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Related Articles")
                                    .font(DesignTypography.title3Font(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(article.relatedArticles, id: \.self) { relatedId in
                                            if let related = ArticleData.articles[relatedId] {
                                                NavigationLink(destination: ArticleDetailPage(articleId: related.id)) {
                                                    RelatedArticleCard(article: related)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    }
                                    .padding(.horizontal, DesignSpacing.sm)
                                }
                                .padding(.horizontal, -DesignSpacing.sm)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    .padding(.bottom, 48)
                }
            } else {
                VStack {
                    BaseHeader(
                        title: "Article Not Found",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back",
                            action: { dismiss() }
                        ),
                        alignment: .leading
                    )
                    .padding(.top, 12)
                    
                    BaseCard {
                        Text("This article could not be found.")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            checkArticleAccess()
        }
        .sheet(isPresented: $showUnlockModal) {
            let balance = PointsService.shared.getBalance()
            PointsSpendModal(
                isPresented: $showUnlockModal,
                cost: 20,
                currentBalance: balance.totalPoints,
                title: "Unlock Full Article",
                message: "Unlock the full article content for 20 points?",
                onConfirm: {
                    handleUnlockArticle()
                },
                onUpgrade: {
                    // Navigate to premium upgrade
                }
            )
        }
    }
    
    private func checkArticleAccess() {
        let (allowed, isPreviewOnly) = AccessControlService.shared.canAccessArticle(articleId: articleId)
        if !allowed {
            // Article not accessible
            return
        }
        isUnlocked = !isPreviewOnly
    }
    
    private func handleUnlockArticle() {
        let result = PointsService.shared.spendPoints(event: "unlock_article", cost: 20)
        if result.success {
            AccessControlService.shared.unlockContent(contentId: articleId, contentType: .article, permanent: true)
            isUnlocked = true
        }
    }
}

struct RelatedArticleCard: View {
    let article: Article
    
    var body: some View {
        BaseCard(variant: .interactive, action: {}) {
            VStack(alignment: .leading, spacing: 12) {
                Text(article.category)
                    .font(DesignTypography.footnoteFont(weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                
                Spacer()
                
                Text(article.title)
                    .font(DesignTypography.headlineFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                    .lineLimit(2)
                
                Text(article.subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(DesignColors.mutedForeground)
                    .lineLimit(2)
            }
            .frame(width: 320, height: 200, alignment: .topLeading)
        }
    }
}

#Preview {
    NavigationStack {
        ArticleDetailPage(articleId: "1")
    }
}

