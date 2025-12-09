//
//  ChangePasswordSheet.swift
//  Aroti
//
//  Change password page
//

import SwiftUI

struct ChangePasswordSheet: View {
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var passwordError: String = ""
    @State private var showSuccessAlert: Bool = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case oldPassword
        case newPassword
        case confirmPassword
    }
    
    var body: some View {
        GlassSheetContainer(title: "Change Password", subtitle: "Update your account password") {
            VStack(spacing: 20) {
                BaseCard {
                    VStack(alignment: .leading, spacing: 20) {
                        // Old Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Old password")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            DesignInput(
                                text: $oldPassword,
                                placeholder: "Enter your current password",
                                isSecure: true
                            )
                        }
                        
                        // New Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("New password")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            DesignInput(
                                text: $newPassword,
                                placeholder: "Enter new password",
                                isError: !passwordError.isEmpty && passwordError.contains("new"),
                                isSecure: true
                            )
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm new password")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            DesignInput(
                                text: $confirmPassword,
                                placeholder: "Confirm new password",
                                isError: !passwordError.isEmpty,
                                isSecure: true
                            )
                            
                            if !passwordError.isEmpty {
                                Text(passwordError)
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.destructive)
                            }
                        }
                        
                        // Password Rules
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password requirements:")
                                .font(DesignTypography.footnoteFont(weight: .medium))
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            passwordRule("At least 8 characters", isValid: newPassword.count >= 8)
                            passwordRule("Must include a number", isValid: newPassword.rangeOfCharacter(from: .decimalDigits) != nil)
                            passwordRule("Must include a letter", isValid: newPassword.rangeOfCharacter(from: .letters) != nil)
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Update Button
                ArotiButton(
                    kind: .primary,
                    title: "Update password",
                    isDisabled: !isFormValid
                ) {
                    updatePassword()
                }
            }
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Password successfully updated.")
            }
        }
    }
    
    private func passwordRule(_ text: String, isValid: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 14))
                .foregroundColor(isValid ? DesignColors.success : DesignColors.mutedForeground)
            Text(text)
                .font(DesignTypography.footnoteFont())
                .foregroundColor(isValid ? DesignColors.mutedForeground : DesignColors.mutedForeground.opacity(0.7))
        }
    }
    
    private var isFormValid: Bool {
        !oldPassword.isEmpty &&
        !newPassword.isEmpty &&
        !confirmPassword.isEmpty &&
        newPassword.count >= 8 &&
        newPassword.rangeOfCharacter(from: .decimalDigits) != nil &&
        newPassword.rangeOfCharacter(from: .letters) != nil &&
        newPassword == confirmPassword
    }
    
    private func updatePassword() {
        // Clear previous errors
        passwordError = ""
        
        // Validate passwords match
        if newPassword != confirmPassword {
            passwordError = "Passwords do not match"
            return
        }
        
        // Validate password requirements
        if newPassword.count < 8 {
            passwordError = "Password must be at least 8 characters"
            return
        }
        
        if newPassword.rangeOfCharacter(from: .decimalDigits) == nil {
            passwordError = "Password must include a number"
            return
        }
        
        if newPassword.rangeOfCharacter(from: .letters) == nil {
            passwordError = "Password must include a letter"
            return
        }
        
        // TODO: Implement actual API call to change password
        // For now, simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Success
            showSuccessAlert = true
            // Clear form
            oldPassword = ""
            newPassword = ""
            confirmPassword = ""
        }
    }
}

