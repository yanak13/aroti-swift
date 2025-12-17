//
//  ReflectionSheet.swift
//  Aroti
//
//  Reflection input sheet
//

import SwiftUI

struct ReflectionSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var reflectionText: String
    @State private var currentText: String
    @State private var isSaving: Bool = false
    
    init(reflectionText: Binding<String>) {
        self._reflectionText = reflectionText
        self._currentText = State(initialValue: reflectionText.wrappedValue)
    }
    
    private let maxLength = 500
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                VStack(spacing: 24) {
                    // Text Input Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Reflection")
                            .font(DesignTypography.headlineFont(weight: .semibold))
                            .foregroundColor(DesignColors.accent)
                        
                        Text("Share your thoughts and feelings about your day or energy.")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        
                        ZStack(alignment: .topLeading) {
                            // Background
                            RoundedRectangle(cornerRadius: ArotiRadius.md)
                                .fill(ArotiColor.inputBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                                        .stroke(ArotiColor.inputBorder, lineWidth: 1)
                                )
                            
                            // Text Editor
                            if #available(iOS 16.0, *) {
                                TextEditor(text: $currentText)
                                    .scrollContentBackground(.hidden)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                                    .padding(12)
                                    .frame(minHeight: 120)
                                    .onChange(of: currentText) { _, newValue in
                                        if newValue.count > maxLength {
                                            currentText = String(newValue.prefix(maxLength))
                                        }
                                    }
                            } else {
                                TextEditor(text: $currentText)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                                    .padding(12)
                                    .frame(minHeight: 120)
                                    .onChange(of: currentText) { newValue in
                                        if newValue.count > maxLength {
                                            currentText = String(newValue.prefix(maxLength))
                                        }
                                    }
                            }
                            
                            // Placeholder
                            if currentText.isEmpty {
                                Text("What insights did you gain today? How are you feeling? What would you like to remember about this day?")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(ArotiColor.inputPlaceholder)
                                    .padding(20)
                                    .allowsHitTesting(false)
                            }
                        }
                        .frame(height: 120)
                        
                        // Character count
                        HStack {
                            Spacer()
                            Text("\(currentText.count)/\(maxLength)")
                                .font(DesignTypography.caption2Font())
                                .foregroundColor(
                                    currentText.count > maxLength * 9 / 10
                                    ? DesignColors.accent
                                    : DesignColors.mutedForeground
                                )
                        }
                    }
                    
                    Spacer()
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancel")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.mutedForeground)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                                        .fill(ArotiColor.surface)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: ArotiRadius.md)
                                                .stroke(ArotiColor.border, lineWidth: 1)
                                        )
                                )
                        }
                        
                        Button(action: {
                            saveReflection()
                        }) {
                            Text(isSaving ? "Saving..." : "Save Reflection")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                                        .fill(
                                            currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                            ? DesignColors.accent.opacity(0.5)
                                            : DesignColors.accent
                                        )
                                )
                        }
                        .disabled(currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSaving)
                    }
                }
                .padding(DesignSpacing.sm)
            }
            .navigationTitle("Your Reflection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Your Reflection")
                        .font(DesignTypography.headlineFont(weight: .semibold))
                        .foregroundColor(DesignColors.accent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveReflection()
                    }
                    .foregroundColor(DesignColors.accent)
                    .disabled(currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveReflection() {
        guard !currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isSaving = true
        HapticFeedback.impactOccurred(.medium)
        
        // Simulate save delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            reflectionText = currentText
            isSaving = false
            dismiss()
        }
    }
}

#Preview {
    ReflectionSheet(reflectionText: .constant(""))
}

