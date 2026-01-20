//
//  LearningHubListingPage.swift
//  Aroti
//
//  Learning Hub articles listing page
//

import SwiftUI

struct LearningHubListingPage: View {
    let selectedCategory: String?
    @Environment(\.dismiss) private var dismiss
    
    var articles: [Article] {
        let allArticles = ArticleData.articles.values
        if let category = selectedCategory, category != "All" {
            return Array(allArticles.filter { $0.category == category })
        }
        return Array(allArticles)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    BaseHeader(
                        title: selectedCategory ?? "Learning Hub",
                        subtitle: "Educational articles & guides",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back to Discovery",
                            action: { dismiss() }
                        ),
                        alignment: .leading,
                        horizontalPadding: 0
                    )
                    .padding(.top, 0)
                    
                    ForEach(articles) { article in
                        NavigationLink(destination: ArticleDetailPage(articleId: article.id)) {
                            LearningHubListItem(article: article)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
            }
            .padding(.top, StickyHeaderBar.contentHeight())
        }
        .navigationBarHidden(true)
    }
}

struct LearningHubListItem: View {
    let article: Article
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.title)
                            .font(DesignTypography.headlineFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                            .lineLimit(2)
                        
                        Text(article.subtitle)
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.5))
                }
                
                HStack(spacing: 8) {
                    if let difficulty = article.difficulty {
                        Text(difficulty.displayName)
                            .font(DesignTypography.footnoteFont(weight: .medium))
                            .foregroundColor(DesignColors.mutedForeground)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                    
                    let readingTime = calculateReadingTime(article: article)
                    Text(readingTime)
                        .font(DesignTypography.footnoteFont(weight: .medium))
                        .foregroundColor(DesignColors.mutedForeground)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    
                    Spacer()
                }
            }
            .padding(DesignSpacing.md)
        }
    }
}
