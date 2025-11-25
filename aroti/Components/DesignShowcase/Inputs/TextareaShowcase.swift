//
//  TextareaShowcase.swift
//  Aroti
//

import SwiftUI

struct TextareaShowcase: View {
    @State private var text = ""
    @State private var disabledText = ""
    
    var body: some View {
        DesignCard(title: "Textarea") {
            VStack(alignment: .leading, spacing: 14) {
                DesignTextarea(text: $text, placeholder: "Enter your reflection...")
                DesignTextarea(text: $disabledText, placeholder: "Enter your reflection...", isDisabled: true)
            }
        }
    }
}

