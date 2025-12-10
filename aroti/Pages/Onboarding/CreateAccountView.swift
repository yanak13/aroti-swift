//
//  CreateAccountView.swift
//  Aroti
//
//  Screen 3: Account creation
//

import SwiftUI

struct CreateAccountView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            ScrollView {
            VStack(spacing: 24) {
                HStack {
                    OnboardingBackButton()
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text("Create your Aroti account")
                        .font(ArotiTextStyle.title1)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                        
                        Text("Save your insights and sync across devices.")
                            .font(ArotiTextStyle.body)
                            .foregroundColor(ArotiColor.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
                    
                    VStack(spacing: 12) {
                        // Apple Sign In
                        ArotiButton(
                            kind: .custom(ArotiButtonStyle(
                                foregroundColor: .white,
                                backgroundColor: .black,
                                cornerRadius: 10,
                                height: 48
                            )),
                            title: "Continue with Apple",
                            icon: Image(systemName: "apple.logo"),
                            action: {
                                // Handle Apple sign in
                                onboardingManager.currentScreen = .birthDate
                            }
                        )
                        
                        // Google Sign In
                        ArotiButton(
                            kind: .custom(ArotiButtonStyle(
                                foregroundColor: ArotiColor.brandGoogleText,
                                backgroundColor: ArotiColor.brandGoogleSurface,
                                borderColor: ArotiColor.brandGoogleBorder,
                                borderWidth: 1,
                                cornerRadius: 10,
                                height: 48
                            )),
                            title: "Continue with Google",
                            icon: Image(systemName: "globe"),
                            action: {
                                // Handle Google sign in
                                onboardingManager.currentScreen = .birthDate
                            }
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    HStack {
                        Rectangle()
                            .fill(ArotiColor.textSecondary.opacity(0.3))
                            .frame(height: 1)
                        Text("Or")
                            .font(ArotiTextStyle.caption1)
                            .foregroundColor(ArotiColor.textSecondary)
                            .padding(.horizontal, 16)
                        Rectangle()
                            .fill(ArotiColor.textSecondary.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 24)
                    
                    BaseCard {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Name (optional)")
                                    .font(ArotiTextStyle.headline)
                                    .foregroundColor(ArotiColor.textPrimary)
                                
                                TextField("Enter your name", text: $name)
                                    .textFieldStyle(OnboardingTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(ArotiTextStyle.headline)
                                    .foregroundColor(ArotiColor.textPrimary)
                                
                                TextField("your@email.com", text: $email)
                                    .textFieldStyle(OnboardingTextFieldStyle())
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(ArotiTextStyle.headline)
                                    .foregroundColor(ArotiColor.textPrimary)
                                
                                HStack {
                                    if showPassword {
                                        TextField("Create a password", text: $password)
                                    } else {
                                        SecureField("Create a password", text: $password)
                                    }
                                    
                                    Button(action: { showPassword.toggle() }) {
                                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(ArotiColor.textSecondary)
                                    }
                                }
                                .textFieldStyle(OnboardingTextFieldStyle())
                                
                                Text("At least 6 characters")
                                    .font(ArotiTextStyle.caption1)
                                    .foregroundColor(ArotiColor.textSecondary)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    ArotiButton(
                        kind: .primary,
                        title: "Continue with Email",
                        isDisabled: email.isEmpty || password.isEmpty || password.count < 6,
                        action: {
                            // Handle email sign up
                            onboardingManager.currentScreen = .birthDate
                        }
                    )
                    .padding(.horizontal, 24)
                    
                    Text("By creating an account, you agree to our Terms & Privacy Policy")
                        .font(ArotiTextStyle.caption1)
                        .foregroundColor(ArotiColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct OnboardingTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(ArotiColor.inputBackground)
            .cornerRadius(ArotiRadius.sm)
            .overlay(
                RoundedRectangle(cornerRadius: ArotiRadius.sm)
                    .stroke(ArotiColor.inputBorder, lineWidth: 1)
            )
            .foregroundColor(ArotiColor.textPrimary)
            .font(ArotiTextStyle.body)
    }
}
