//
//  LoginView.swift
//  Aroti
//
//  Login screen with Keycloak authentication
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authController = AuthController.shared
    @State private var showError = false
    @State private var isMockModeEnabled = MockModeService.shared.isEnabled
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App Logo/Title
            VStack(spacing: 16) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.purple)
                
                Text("Aroti")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your journey to inner wisdom")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Login Button
            Button(action: {
                Task {
                    await authController.login()
                    if authController.error != nil {
                        showError = true
                    }
                }
            }) {
                HStack {
                    if authController.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Image(systemName: "person.circle.fill")
                        Text("Sign in with Keycloak")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(authController.isLoading)
            .padding(.horizontal, 40)
            
            // Skip Auth Button (Development/Testing)
            Button(action: {
                authController.skipAuth()
            }) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Skip Authentication")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.top, 8)
            
            // Mock Mode Toggle (Development/Testing)
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "testtube.2")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                    Text("Mock Mode")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                    Spacer()
                    Toggle("", isOn: $isMockModeEnabled)
                        .labelsHidden()
                        .onChange(of: isMockModeEnabled) { _, newValue in
                            MockModeService.shared.isEnabled = newValue
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                
                Text("Use mock data for all features (Home, Specialists, etc.)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            .padding(.top, 8)
            
            if let error = authController.error {
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .alert("Authentication Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authController.error?.localizedDescription ?? "An error occurred during authentication")
        }
        .onReceive(NotificationCenter.default.publisher(for: .mockModeChanged)) { _ in
            isMockModeEnabled = MockModeService.shared.isEnabled
        }
    }
}

#Preview {
    LoginView()
}
