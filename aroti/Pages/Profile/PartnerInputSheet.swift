//
//  PartnerInputSheet.swift
//  Aroti
//
//  Partner input modal for compatibility
//

import SwiftUI

struct PartnerInputSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var partnerName: String = ""
    @State private var partnerBirthDate: Date = Date()
    @State private var partnerBirthTime: Date? = nil
    @State private var partnerLocation: String = ""
    @State private var showUnlockSheet = false
    
    let onCalculateCompatibility: (String, Date, Date?, String) -> Void
    
    init(onCalculateCompatibility: @escaping (String, Date, Date?, String) -> Void) {
        self.onCalculateCompatibility = onCalculateCompatibility
    }
    
    private var canCalculate: Bool {
        !partnerName.isEmpty && !partnerLocation.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Partner's Name Section
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Partner's Name")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                TextField("Enter name", text: $partnerName)
                                    .textFieldStyle(ProfileTextFieldStyle())
                            }
                            .frame(height: 100)
                        }
                        
                        // Birth Date Section
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Birth Date")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                DatePicker(
                                    "",
                                    selection: $partnerBirthDate,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.compact)
                                .accentColor(DesignColors.accent)
                                .tint(DesignColors.accent)
                                .colorScheme(.dark)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: ArotiRadius.sm)
                                        .fill(ArotiColor.inputBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: ArotiRadius.sm)
                                                .stroke(ArotiColor.inputBorder, lineWidth: 1)
                                        )
                                )
                                .foregroundColor(DesignColors.foreground)
                            }
                            .frame(height: 100)
                        }
                        
                        // Birth Location Section
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Birth Location")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                TextField("City, State, Country", text: $partnerLocation)
                                    .textFieldStyle(ProfileTextFieldStyle())
                            }
                            .frame(height: 100)
                        }
                        
                        // Birth Time Section (Optional)
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Birth Time (Optional)")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                DatePicker(
                                    "",
                                    selection: Binding(
                                        get: { partnerBirthTime ?? partnerBirthDate },
                                        set: { partnerBirthTime = $0 }
                                    ),
                                    displayedComponents: [.hourAndMinute]
                                )
                                .datePickerStyle(.compact)
                                .accentColor(DesignColors.accent)
                                .tint(DesignColors.accent)
                                .colorScheme(.dark)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: ArotiRadius.sm)
                                        .fill(ArotiColor.inputBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: ArotiRadius.sm)
                                                .stroke(ArotiColor.inputBorder, lineWidth: 1)
                                        )
                                )
                                .foregroundColor(DesignColors.foreground)
                            }
                            .frame(height: 100)
                        }
                        
                        // Calculate Button
                        ArotiButton(
                            kind: .primary,
                            action: {
                                guard canCalculate else { return }
                                
                                // Haptic feedback
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                                
                                // Check access before calculating
                                let access = AccessControlService.shared.canAccessCompatibility()
                                if access.allowed {
                                    onCalculateCompatibility(
                                        partnerName,
                                        partnerBirthDate,
                                        partnerBirthTime,
                                        partnerLocation
                                    )
                                    dismiss()
                                } else {
                                    showUnlockSheet = true
                                }
                            },
                            label: {
                                Text("Calculate Compatibility")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                            }
                        )
                        .disabled(!canCalculate)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    .padding(.top, DesignSpacing.md)
                    .padding(.bottom, 100) // Extra padding for fixed button
                }
            }
            .navigationTitle("Add Partner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.foreground)
                }
            }
            .sheet(isPresented: $showUnlockSheet) {
                CompatibilityUnlockSheet(
                    isPresented: $showUnlockSheet,
                    onUnlock: {
                        let success = AccessControlService.shared.recordCompatibilityCheck()
                        if success {
                            onCalculateCompatibility(
                                partnerName,
                                partnerBirthDate,
                                partnerBirthTime,
                                partnerLocation
                            )
                            showUnlockSheet = false
                            dismiss()
                        }
                    }
                )
            }
        }
    }
}

