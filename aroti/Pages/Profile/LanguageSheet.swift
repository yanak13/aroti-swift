//
//  LanguageSheet.swift
//  Aroti
//
//  Language popup page
//

import SwiftUI

struct LanguageSheet: View {
    @State private var matchDevice: Bool = true
    @State private var selectedLanguage: String = "en"
    
    private let languageKey = "aroti_app_language"
    private let matchDeviceKey = "aroti_match_device_language"
    
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
        GlassSheetContainer(title: "Language", subtitle: "Match device or choose manually") {
            VStack(spacing: 20) {
                // Match Device Language Toggle
                BaseCard {
                    HStack {
                        HStack(spacing: 12) {
                            Image(systemName: "globe")
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.accent)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.05))
                                )
                            
                            Text("Match device language")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                        }
                        Spacer()
                        Toggle("", isOn: $matchDevice)
                            .tint(DesignColors.accent)
                            .labelsHidden()
                            .onChange(of: matchDevice) { newValue in
                                saveMatchDevicePreference(value: newValue)
                            }
                    }
                }
                
                // App Language List
                BaseCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "globe")
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.accent)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.05))
                                )
                            
                            Text("App Language")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                        }
                        
                        VStack(spacing: 8) {
                            ForEach(languages, id: \.code) { language in
                                Button(action: {
                                    if !matchDevice {
                                        selectedLanguage = language.code
                                        saveLanguagePreference(code: language.code)
                                    }
                                }) {
                                    HStack {
                                        Text(language.name)
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.foreground)
                                        Spacer()
                                        if selectedLanguage == language.code && !matchDevice {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 16))
                                                .foregroundColor(DesignColors.accent)
                                        }
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(
                                                selectedLanguage == language.code && !matchDevice
                                                ? DesignColors.accent.opacity(0.1)
                                                : Color.clear
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(
                                                        selectedLanguage == language.code && !matchDevice
                                                        ? DesignColors.accent.opacity(0.3)
                                                        : Color.clear,
                                                        lineWidth: 1
                                                    )
                                            )
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(matchDevice)
                                .opacity(matchDevice ? 0.5 : 1.0)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onAppear { loadLanguagePreferences() }
        }
    }
    
    private func loadLanguagePreferences() {
        matchDevice = UserDefaults.standard.object(forKey: matchDeviceKey) as? Bool ?? true
        selectedLanguage = UserDefaults.standard.string(forKey: languageKey) ?? "en"
    }
    
    private func saveLanguagePreference(code: String) {
        UserDefaults.standard.set(code, forKey: languageKey)
    }
    
    private func saveMatchDevicePreference(value: Bool) {
        UserDefaults.standard.set(value, forKey: matchDeviceKey)
    }
}
