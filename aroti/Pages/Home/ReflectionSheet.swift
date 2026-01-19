//
//  ReflectionSheet.swift
//  Aroti
//
//  Reflection detail page - journal entry style
//

import SwiftUI

struct ReflectionSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentText: String = ""
    @State private var isSaving: Bool = false
    @State private var isEditing: Bool = false
    @State private var editingIndex: Int? = nil
    @State private var existingEntries: [ReflectionEntry] = []
    let prompt: String
    
    private let manager = DailyStateManager.shared
    
    init(prompt: String = "") {
        self.prompt = prompt
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        if existingEntries.isEmpty && !isEditing {
                            // EMPTY STATE - Invitation to write
                            emptyStateView()
                                .padding(.horizontal, DesignSpacing.sm)
                                .padding(.top, DesignSpacing.md)
                        } else if isEditing {
                            // EDITING STATE - Input form
                            editingStateView()
                                .padding(.horizontal, DesignSpacing.sm)
                                .padding(.top, DesignSpacing.md)
                        } else {
                            // FILLED STATE - Show all reflection cards
                            filledStateView()
                                .padding(.horizontal, DesignSpacing.sm)
                                .padding(.top, DesignSpacing.md)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Your Reflection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.foreground.opacity(0.7)) // Reduced visual weight
                }
            }
            .onAppear {
                loadReflection()
            }
        }
    }
    
    // MARK: - Empty State
    
    private func emptyStateView() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            // Soft prompt (editorial, not instructional)
            VStack(alignment: .leading, spacing: 12) {
                Text(getSoftPrompt())
                    .font(DesignTypography.title2Font(weight: .regular))
                    .foregroundColor(DesignColors.foreground.opacity(0.9))
                    .lineSpacing(4)
                
                // Context reminder (optional but good)
                Text("This reflection is just for you.")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.top, 4)
            }
            .padding(.top, DesignSpacing.lg)
            
            // Reflection input (journal-style)
            ZStack(alignment: .topLeading) {
                // Soft inset / frosted background (no visible border)
                RoundedRectangle(cornerRadius: ArotiRadius.lg)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 18/255, green: 16/255, blue: 26/255, opacity: 0.6),
                                Color(red: 22/255, green: 19/255, blue: 30/255, opacity: 0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Text Editor
                if #available(iOS 16.0, *) {
                    TextEditor(text: $currentText)
                        .scrollContentBackground(.hidden)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .padding(20) // Large padding
                        .frame(minHeight: 200)
                } else {
                    TextEditor(text: $currentText)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .padding(20)
                        .frame(minHeight: 200)
                }
                
                // Placeholder
                if currentText.isEmpty {
                    Text("Write a few words…")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                        .padding(26)
                        .allowsHitTesting(false)
                }
            }
            .frame(minHeight: 200)
            
            // Actions (closer to text input)
            VStack(spacing: 12) {
                // Primary: Save Reflection
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
                                    ? DesignColors.accent.opacity(0.4)
                                    : DesignColors.accent.opacity(0.7) // No urgency color
                                )
                        )
                }
                .disabled(currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSaving)
                
                // Secondary: Cancel (very subtle)
                Button(action: {
                    isEditing = false
                    editingIndex = nil
                    currentText = ""
                }) {
                    Text("Cancel")
                        .font(DesignTypography.subheadFont(weight: .regular))
                        .foregroundColor(DesignColors.mutedForeground)
                }
            }
            .padding(.top, DesignSpacing.sm) // Reduced spacing to bring button closer
        }
    }
    
    // MARK: - Editing State
    
    private func editingStateView() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            // Soft prompt (editorial, not instructional)
            VStack(alignment: .leading, spacing: 12) {
                Text(getSoftPrompt())
                    .font(DesignTypography.title2Font(weight: .regular))
                    .foregroundColor(DesignColors.foreground.opacity(0.9))
                    .lineSpacing(4)
                
                // Context reminder (optional but good)
                Text("This reflection is just for you.")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.top, 4)
            }
            .padding(.top, DesignSpacing.lg)
            
            // Reflection input (journal-style)
            ZStack(alignment: .topLeading) {
                // Soft inset / frosted background (no visible border)
                RoundedRectangle(cornerRadius: ArotiRadius.lg)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 18/255, green: 16/255, blue: 26/255, opacity: 0.6),
                                Color(red: 22/255, green: 19/255, blue: 30/255, opacity: 0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Text Editor
                if #available(iOS 16.0, *) {
                    TextEditor(text: $currentText)
                        .scrollContentBackground(.hidden)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .padding(20) // Large padding
                        .frame(minHeight: 200)
                } else {
                    TextEditor(text: $currentText)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .padding(20)
                        .frame(minHeight: 200)
                }
                
                // Placeholder
                if currentText.isEmpty {
                    Text("Write a few words…")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                        .padding(26)
                        .allowsHitTesting(false)
                }
            }
            .frame(minHeight: 200)
            
            // Actions (closer to text input)
            VStack(spacing: 12) {
                // Primary: Save Reflection
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
                                    ? DesignColors.accent.opacity(0.4)
                                    : DesignColors.accent.opacity(0.7) // No urgency color
                                )
                        )
                }
                .disabled(currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSaving)
                
                // Secondary: Cancel (very subtle)
                Button(action: {
                    isEditing = false
                    editingIndex = nil
                    currentText = ""
                }) {
                    Text("Cancel")
                        .font(DesignTypography.subheadFont(weight: .regular))
                        .foregroundColor(DesignColors.mutedForeground)
                }
            }
            .padding(.top, DesignSpacing.sm) // Reduced spacing to bring button closer
        }
    }
    
    // MARK: - Filled State
    
    private func filledStateView() -> some View {
        VStack(spacing: DesignSpacing.md) {
            // Show all reflection cards
            ForEach(Array(existingEntries.enumerated()), id: \.offset) { index, entry in
                reflectionCardView(entry: entry, index: index)
            }
            
            // Add Reflection button (proper button style) - below all cards
            Button(action: {
                isEditing = true
                editingIndex = nil
                currentText = ""
            }) {
                Text("Add Reflection")
                    .font(DesignTypography.subheadFont(weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                            .fill(DesignColors.accent.opacity(0.7))
                    )
            }
            .padding(.top, DesignSpacing.sm)
        }
    }
    
    private func reflectionCardView(entry: ReflectionEntry, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Time label (quiet)
            HStack {
                Text(formatTimeLabel(entry.timestamp))
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground)
                Spacer()
            }
            
            // Reflection text (unchanged, as written by user)
            Text(entry.text)
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.foreground)
                .lineSpacing(8) // Larger line height
                .fixedSize(horizontal: false, vertical: true)
            
            // Optional subtle divider
            Rectangle()
                .fill(DesignColors.mutedForeground.opacity(0.1))
                .frame(height: 1)
                .padding(.top, 8)
            
            // App mark (very low opacity, optional)
            HStack {
                Spacer()
                Text("Aroti")
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.foreground.opacity(0.2))
            }
        }
        .padding(DesignSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            // Same card style as InsightCard
            RoundedRectangle(cornerRadius: ArotiRadius.lg)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 16/255, green: 14/255, blue: 24/255, opacity: 0.95),
                            Color(red: 20/255, green: 17/255, blue: 28/255, opacity: 0.92),
                            Color(red: 18/255, green: 16/255, blue: 26/255, opacity: 0.93),
                            Color(red: 22/255, green: 19/255, blue: 30/255, opacity: 0.90)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: ArotiRadius.lg)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            Color.white.opacity(0.05),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .overlay(
            // Edit button in top right corner
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isEditing = true
                        editingIndex = index
                        currentText = entry.text
                    }) {
                        Text("Edit reflection")
                            .font(DesignTypography.caption2Font())
                            .foregroundColor(DesignColors.accent.opacity(0.8))
                    }
                    .padding(.top, DesignSpacing.md)
                    .padding(.trailing, DesignSpacing.md)
                }
                Spacer()
            }
        )
    }
    
    // MARK: - Helpers
    
    private func getSoftPrompt() -> String {
        // Use provided prompt or default to softer options
        if !prompt.isEmpty {
            // Transform instructional prompts to softer ones
            let softPrompts = [
                "A moment to check in with yourself",
                "What feels present right now?",
                "Take a moment to reflect"
            ]
            // Use prompt if it's already soft, otherwise use first soft prompt
            if softPrompts.contains(where: { prompt.contains($0) }) {
                return prompt
            }
        }
        return "A moment to check in with yourself"
    }
    
    private func formatTimeLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        return "Today • \(timeString)"
    }
    
    private func loadReflection() {
        existingEntries = manager.loadTodayReflections()
    }
    
    private func saveReflection() {
        guard !currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isSaving = true
        HapticFeedback.impactOccurred(.light) // Lighter haptic
        
        // Save or update reflection
        if let index = editingIndex {
            manager.updateReflection(at: index, text: currentText.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            manager.saveTodayReflection(currentText.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        // Simulate save delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            loadReflection()
            isSaving = false
            isEditing = false
            editingIndex = nil
            currentText = ""
        }
    }
}

#Preview {
    ReflectionSheet(prompt: "What felt most present for you today?")
}
