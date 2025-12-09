//
//  ChangeEmailSheet.swift
//  Aroti
//
//  Change email page
//

import SwiftUI

struct ChangeEmailSheet: View {
    @State private var currentPassword: String = ""
    @State private var newEmail: String = ""
    @State private var confirmEmail: String = ""
    @State private var currentPasswordError: String = ""
    @State private var emailError: String = ""
    @State private var showSuccessAlert: Bool = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case currentPassword
        case newEmail
        case confirmEmail
    }
    
    var body: some View {
        GlassSheetContainer(title: "Change Email", subtitle: "Update the email associated with your Aroti account") {
            VStack(spacing: 20) {
                BaseCard {
                    VStack(alignment: .leading, spacing: 20) {
                        // Current Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current password")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            DesignInput(
                                text: $currentPassword,
                                placeholder: "Enter your current password",
                                isSecure: true
                            )
                            
                            if !currentPasswordError.isEmpty {
                                Text(currentPasswordError)
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.destructive)
                            }
                        }
                        
                        // New Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("New email")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            DesignInput(
                                text: $newEmail,
                                placeholder: "Enter new email address",
                                isError: !emailError.isEmpty && emailError.contains("email")
                            )
                        }
                        
                        // Confirm Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm new email")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            DesignInput(
                                text: $confirmEmail,
                                placeholder: "Confirm new email address",
                                isError: !emailError.isEmpty
                            )
                            
                            if !emailError.isEmpty {
                                Text(emailError)
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.destructive)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Save Button
                ArotiButton(
                    kind: .primary,
                    title: "Save changes",
                    isDisabled: !isFormValid
                ) {
                    saveEmailChanges()
                }
            }
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your email has been updated.")
            }
        }
    }
    
    private var isFormValid: Bool {
        !currentPassword.isEmpty &&
        !newEmail.isEmpty &&
        !confirmEmail.isEmpty &&
        isValidEmail(newEmail) &&
        newEmail == confirmEmail
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func saveEmailChanges() {
        // Clear previous errors
        currentPasswordError = ""
        emailError = ""
        
        // Validate emails match
        if newEmail != confirmEmail {
            emailError = "Email addresses do not match"
            return
        }
        
        // Validate email format
        if !isValidEmail(newEmail) {
            emailError = "Please enter a valid email address"
            return
        }
        
        // TODO: Implement actual API call to change email
        // For now, simulate validation
        if currentPassword.isEmpty {
            currentPasswordError = "Incorrect password"
            return
        }
        
        // Simulate API call
        // In production, this would call your authentication service
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Check if email already in use (simulated)
            if newEmail == "existing@example.com" {
                emailError = "Email already in use"
                return
            }
            
            // Success
            showSuccessAlert = true
            // Clear form
            currentPassword = ""
            newEmail = ""
            confirmEmail = ""
        }
    }
}

