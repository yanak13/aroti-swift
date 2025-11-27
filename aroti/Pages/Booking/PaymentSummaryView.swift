//
//  PaymentSummaryView.swift
//  Aroti
//
//  Payment processing page
//

import SwiftUI

struct PaymentSummaryView: View {
    let specialist: Specialist
    let selectedDate: Date
    let selectedTime: String
    @Environment(\.dismiss) private var dismiss
    @State private var paymentMethod: PaymentMethod?
    @State private var agreedToTerms: Bool = false
    @State private var cardNumber: String = ""
    @State private var cardExpiry: String = ""
    @State private var cardCVC: String = ""
    @State private var isProcessing: Bool = false
    @State private var navigationPath = NavigationPath()
    
    enum PaymentMethod {
        case applePay
        case card
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Specialist Summary
                        BaseCard {
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                    .fill(ArotiColor.accent.opacity(0.2))
                                    .frame(width: 64, height: 64)
                                    .overlay(
                                        Text(specialist.name.prefix(2).uppercased())
                                            .font(DesignTypography.headlineFont(weight: .semibold))
                                            .foregroundColor(ArotiColor.accent)
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(specialist.name)
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(specialist.specialty)
                                        .font(DesignTypography.subheadFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Text(formatDate(selectedDate) + " at " + formatTime(selectedTime))
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, DesignSpacing.md)
                        .padding(.top, 24)
                        
                        // Payment Method Selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Payment Method")
                                .font(DesignTypography.subheadFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                                .padding(.horizontal, DesignSpacing.md)
                            
                            VStack(spacing: 12) {
                                // Apple Pay
                                PaymentMethodButton(
                                    title: "Apple Pay",
                                    icon: Image(systemName: "applelogo"),
                                    isSelected: paymentMethod == .applePay
                                ) {
                                    paymentMethod = .applePay
                                }
                                
                                // Credit Card
                                PaymentMethodButton(
                                    title: "Credit Card",
                                    icon: Image(systemName: "creditcard"),
                                    isSelected: paymentMethod == .card
                                ) {
                                    paymentMethod = .card
                                }
                            }
                            .padding(.horizontal, DesignSpacing.md)
                        }
                        
                        // Card Form (shown when card is selected)
                        if paymentMethod == .card {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Card Details")
                                        .font(DesignTypography.subheadFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    DesignInput(
                                        text: $cardNumber,
                                        placeholder: "Card Number",
                                        leadingIcon: Image(systemName: "creditcard")
                                    )
                                    
                                    HStack(spacing: 12) {
                                        DesignInput(
                                            text: $cardExpiry,
                                            placeholder: "MM/YY"
                                        )
                                        
                                        DesignInput(
                                            text: $cardCVC,
                                            placeholder: "CVC",
                                            isSecure: true
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSpacing.md)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                        
                        // Price Breakdown
                        BaseCard {
                            VStack(spacing: 12) {
                                SummaryRow(label: "Session", value: "$\(specialist.price)")
                                SummaryRow(label: "Platform fee", value: "$0")
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                
                                HStack {
                                    Text("Total")
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Spacer()
                                    
                                    Text("$\(specialist.price)")
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                }
                            }
                        }
                        .padding(.horizontal, DesignSpacing.md)
                        
                        // Terms Agreement
                        HStack(alignment: .top, spacing: 12) {
                            Button(action: { agreedToTerms.toggle() }) {
                                Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(agreedToTerms ? ArotiColor.accent : DesignColors.mutedForeground)
                                    .font(.system(size: 20))
                            }
                            
                            Text("I agree to the terms and conditions and cancellation policy")
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.foreground.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, DesignSpacing.md)
                        
                        // Confirm Button
                        ArotiButton(
                            kind: .custom(.accentCard()),
                            title: isProcessing ? "Processing..." : "Confirm Booking",
                            isDisabled: !canConfirm,
                            action: {
                                processPayment()
                            }
                        )
                        .padding(.horizontal, DesignSpacing.md)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(DesignColors.foreground.opacity(0.6))
                            .font(.system(size: 20))
                            .frame(width: 40, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                            )
                    }
                }
            }
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: BookingDestination.self) { destination in
                switch destination {
                case .confirmation(let specialist, let date, let time):
                    BookingConfirmationView(specialist: specialist, selectedDate: date, selectedTime: time)
                default:
                    EmptyView()
                }
            }
        }
    }
    
    private var canConfirm: Bool {
        paymentMethod != nil && agreedToTerms && !isProcessing
    }
    
    private func processPayment() {
        isProcessing = true
        // Process payment logic here
        // On success, navigate to confirmation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isProcessing = false
            navigationPath.append(BookingDestination.confirmation(specialist, selectedDate, selectedTime))
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ timeString: String) -> String {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return timeString
        }
        
        let period = hour >= 12 ? "PM" : "AM"
        let hour12 = hour % 12 == 0 ? 12 : hour % 12
        return String(format: "%d:%02d %@", hour12, minute, period)
    }
}

// Payment Method Button
struct PaymentMethodButton: View {
    let title: String
    let icon: Image
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                icon
                    .foregroundColor(isSelected ? ArotiColor.accent : DesignColors.mutedForeground)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(DesignTypography.subheadFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ArotiColor.accent)
                        .font(.system(size: 20))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: DesignRadius.secondary)
                    .fill(isSelected ? ArotiColor.accentSoft : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignRadius.secondary)
                            .stroke(isSelected ? ArotiColor.accent.opacity(0.5) : DesignColors.glassBorder, lineWidth: 1)
                    )
            )
        }
    }
}

