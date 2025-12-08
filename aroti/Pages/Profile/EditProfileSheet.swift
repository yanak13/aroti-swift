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
    @State private var location: String
    @State private var birthDate: Date
    @State private var birthTime: Date
    
    let onSave: (String, String) -> Void
    
    init(userName: Binding<String>, userLocation: Binding<String>, onSave: @escaping (String, String) -> Void) {
        self._userName = userName
        self._userLocation = userLocation
        self.onSave = onSave
        _name = State(initialValue: userName.wrappedValue)
        
        // Load user data for birth details
        let userData = DailyStateManager.shared.loadUserData() ?? UserData.default
        _location = State(initialValue: userData.birthLocation ?? userLocation.wrappedValue)
        _birthDate = State(initialValue: userData.birthDate ?? Date())
        _birthTime = State(initialValue: userData.birthTime ?? userData.birthDate ?? Date())
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !location.isEmpty
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
                            .frame(height: 100)
                        }
                        
                        // Location Section
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Birth Location")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                TextField("Enter your birth location", text: $location)
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
                                    selection: $birthDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.compact)
                                .accentColor(DesignColors.accent)
                                .tint(DesignColors.accent)
                                .colorScheme(.dark)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
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
                            .frame(height: 100)
                        }
                        
                        // Birth Time Section
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Birth Time")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                DatePicker(
                                    "",
                                    selection: $birthTime,
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
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ArotiColor.inputBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(ArotiColor.inputBorder, lineWidth: 1)
                                        )
                                )
                                .foregroundColor(DesignColors.foreground)
                            }
                            .frame(height: 100)
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
            .preferredColorScheme(.dark)
            .environment(\.colorScheme, .dark)
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
        // Save name and location
        onSave(name, location)
        
        // Update UserData with all fields
        let existingData = DailyStateManager.shared.loadUserData() ?? UserData.default
        let updatedData = UserData(
            name: name,
            sunSign: existingData.sunSign,
            moonSign: existingData.moonSign,
            birthDate: birthDate,
            birthTime: birthTime,
            birthLocation: location,
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
            .foregroundColor(.white)
            .tint(DesignColors.accent)
            .colorScheme(.dark)
            .accentColor(DesignColors.accent)
    }
}

