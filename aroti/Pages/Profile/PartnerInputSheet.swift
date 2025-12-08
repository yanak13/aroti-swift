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
                        VStack(spacing: 12) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 48))
                                .foregroundColor(DesignColors.accent)
                            
                            Text("Add Partner")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("Enter your partner's details to explore compatibility")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Partner's Name")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                TextField("Enter name", text: $partnerName)
                                    .textFieldStyle(ProfileTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Birth Date")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                DatePicker("", selection: $partnerBirthDate, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .tint(DesignColors.accent)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Birth Location")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                TextField("City, State, Country", text: $partnerLocation)
                                    .textFieldStyle(ProfileTextFieldStyle())
                            }
                        }
                        .padding()
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Birth Time (Optional)")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                DatePicker("", selection: Binding(
                                    get: { partnerBirthTime ?? partnerBirthDate },
                                    set: { partnerBirthTime = $0 }
                                ), displayedComponents: [.hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .tint(DesignColors.accent)
                            }
                            
                            ArotiButton(
                                kind: .primary,
                                action: {
                                    guard canCalculate else { return }
                                    
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
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Add Partner")
            .navigationBarTitleDisplayMode(.inline)
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

