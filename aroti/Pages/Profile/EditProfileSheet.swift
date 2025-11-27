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
    @State private var birthDate: Date = Date()
    @State private var birthTime: Date = Date()
    @State private var hasBirthTime: Bool = false
    
    let onSave: (String, String) -> Void
    
    init(userName: Binding<String>, userLocation: Binding<String>, onSave: @escaping (String, String) -> Void) {
        self._userName = userName
        self._userLocation = userLocation
        self.onSave = onSave
        _name = State(initialValue: userName.wrappedValue)
        _location = State(initialValue: userLocation.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            TextField("Enter your full name", text: $name)
                                .textFieldStyle(ProfileTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Birth Date")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            DatePicker("", selection: $birthDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .tint(DesignColors.accent)
                            
                            Text("Required for chart calculations")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Include Birth Time", isOn: $hasBirthTime)
                                .tint(DesignColors.accent)
                            
                            if hasBirthTime {
                                DatePicker("", selection: $birthTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .tint(DesignColors.accent)
                                
                                Text("Optional • If unknown, Rising sign will be estimated")
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Birth Location")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            TextField("City, State, Country", text: $location)
                                .textFieldStyle(ProfileTextFieldStyle())
                            
                            Text("Used for accurate chart positioning")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.foreground)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(name, location)
                        dismiss()
                    }
                    .foregroundColor(DesignColors.accent)
                    .fontWeight(.semibold)
                }
            }
        }
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

