//
//  CTAButtonShowcase.swift
//  Aroti
//

import SwiftUI

struct CTAButtonShowcase: View {
    private let gradient = [ArotiColor.accent.opacity(0.9), ArotiColor.accent]
    
    var body: some View {
        DesignCard(title: "CTAButton") {
            VStack(alignment: .leading, spacing: 14) {
                ArotiButton(
                    kind: .custom(.gradientFilled(colors: gradient)),
                    isDisabled: false,
                    action: {},
                    label: {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 20))
                            Text("Start Free Trial")
                        }
                    }
                )
                
                ArotiButton(
                    kind: .custom(.gradientFilled(colors: gradient, height: ArotiButtonHeight.large, cornerRadius: DesignRadius.pill)),
                    isDisabled: false,
                    action: {},
                    label: {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 20))
                            Text("Pill Variant")
                        }
                    }
                )
            }
        }
    }
}
