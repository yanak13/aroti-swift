//
//  LanguageSheet.swift
//  Aroti
//
//  Language popup page
//

import SwiftUI

struct LanguageSheet: View {
    @State private var selectedLanguage: String = "en"
    @State private var showRestartBanner: Bool = false
    @State private var previousLanguage: String = "en"
    
    private let languageKey = "aroti_app_language"
    
    private let languages: [(code: String, name: String)] = [
        ("en", "English"),
        ("es", "Spanish"),
        ("fr", "French"),
        ("de", "German"),
        ("it", "Italian"),
        ("pt", "Portuguese"),
        ("zh", "Chinese"),
        ("ja", "Japanese"),
        ("ko", "Korean"),
        ("ar", "Arabic"),
        ("hi", "Hindi"),
        ("ru", "Russian")
    ]
    
    var body: some View {
        GlassSheetContainer(title: "Languages", subtitle: "Choose your preferred app language") {
            VStack(spacing: 20) {
                // Info Banner (shown if language change requires restart)
                if showRestartBanner {
                    BaseCard {
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(DesignColors.accent)
                            Text("App content will update after restart.")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.foreground)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                // Language List
                BaseCard {
                    VStack(spacing: 12) {
                        ForEach(languages, id: \.code) { language in
                            BaseCard(variant: .interactive, action: {
                                if selectedLanguage != language.code {
                                    previousLanguage = selectedLanguage
                                    selectedLanguage = language.code
                                    saveLanguagePreference(code: language.code)
                                    // Show banner if language changed
                                    showRestartBanner = true
                                }
                            }) {
                                HStack {
                                    Text(language.name)
                                        .font(DesignTypography.bodyFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    Spacer()
                                    if selectedLanguage == language.code {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(DesignColors.accent)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear { loadLanguagePreferences() }
        }
    }
    
    private func loadLanguagePreferences() {
        selectedLanguage = UserDefaults.standard.string(forKey: languageKey) ?? "en"
        previousLanguage = selectedLanguage
    }
    
    private func saveLanguagePreference(code: String) {
        UserDefaults.standard.set(code, forKey: languageKey)
    }
}
