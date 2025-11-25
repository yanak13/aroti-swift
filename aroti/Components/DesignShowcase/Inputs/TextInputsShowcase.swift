//
//  TextInputsShowcase.swift
//  Aroti
//

import SwiftUI

struct TextInputsShowcase: View {
    @State private var textInput = ""
    @State private var emailInput = ""
    @State private var passwordInput = ""
    @State private var disabledInput = ""
    @State private var errorInput = ""
    
    var body: some View {
        DesignCard(title: "Text Input") {
            VStack(alignment: .leading, spacing: 14) {
                DesignInput(text: $textInput, placeholder: "Enter text...")
                DesignInput(text: $emailInput, placeholder: "Email address")
                DesignInput(text: $passwordInput, placeholder: "Password", isSecure: true)
                DesignInput(text: $disabledInput, placeholder: "Disabled input", isDisabled: true)
                
                VStack(alignment: .leading, spacing: 8) {
                    DesignInput(text: $errorInput, placeholder: "Error state", isError: true)
                    Text("This field is required")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.destructive)
                }
            }
        }
    }
}

