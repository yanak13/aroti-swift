//
//  LoginView.swift
//  Aroti
//
//  Login view with Keycloak OAuth integration
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authController = AuthController.shared
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 24) {
            // App logo/header
            VStack(spacing: 16) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.purple)
                
                Text("Aroti")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your spiritual journey begins here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Sign in button
            Button(action: {
                Task {
                    await signIn()
                }
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign in with Keycloak")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isLoading ? Color.gray : Color.purple)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(isLoading)
            .padding(.horizontal, 32)
            
            // Error message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func signIn() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authController.signIn()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

#Preview {
    LoginView()
}
