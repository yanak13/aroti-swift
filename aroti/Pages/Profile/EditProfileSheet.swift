//
//  EditProfileSheet.swift
//  Aroti
//
//  Edit Profile modal sheet
//

import SwiftUI

struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var userName: String
    @Binding var userLocation: String
    
    @State private var name: String
    
    let onSave: (String, String) -> Void
    
    init(userName: Binding<String>, userLocation: Binding<String>, onSave: @escaping (String, String) -> Void) {
        self._userName = userName
        self._userLocation = userLocation
        self.onSave = onSave
        _name = State(initialValue: userName.wrappedValue)
    }
    
    private var isFormValid: Bool {
        !name.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Full Name Section
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Full Name")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                TextField("Enter your full name", text: $name)
                                    .textFieldStyle(ProfileTextFieldStyle())
                            }
                        }
                        
                        // Location Display (Read-only)
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Location")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(userLocation.isEmpty ? "Not set" : userLocation)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(userLocation.isEmpty ? DesignColors.mutedForeground : DesignColors.foreground)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(ArotiColor.inputBackground.opacity(0.5))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(ArotiColor.inputBorder.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                                
                                Text("Location is set during onboarding")
                                    .font(DesignTypography.caption2Font())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                        
                        // Save Button
                        ArotiButton(
                            kind: .primary,
                            action: {
                                saveProfile()
                            },
                            label: {
                                Text("Save")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                            }
                        )
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.foreground)
                }
            }
        }
    }
    
    private func saveProfile() {
        // Save name only (location is from onboarding)
        onSave(name, userLocation)
        
        // Update UserData name
        let existingData = DailyStateManager.shared.loadUserData() ?? UserData.default
        let updatedData = UserData(
            name: name,
            sunSign: existingData.sunSign,
            moonSign: existingData.moonSign,
            birthDate: existingData.birthDate,
            traits: existingData.traits,
            isPremium: existingData.isPremium
        )
        DailyStateManager.shared.saveUserData(updatedData)
        
        dismiss()
    }
}

struct ProfileTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ArotiColor.inputBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ArotiColor.inputBorder, lineWidth: 1)
                    )
            )
            .foregroundColor(DesignColors.foreground)
    }
}

