//
//  BookingConfirmationView.swift
//  Aroti
//
//  Booking confirmation page
//

import SwiftUI

struct BookingConfirmationView: View {
    let specialist: Specialist
    let selectedDate: Date
    let selectedTime: String
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToHome: Bool = false
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            VStack(spacing: 0) {
                // Close Button (top-right)
                HStack {
                    Spacer()
                    Button(action: { navigateToHome = true }) {
                        Image(systemName: "xmark")
                            .foregroundColor(DesignColors.foreground.opacity(0.6))
                            .font(.system(size: 20))
                            .frame(width: 40, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                            )
                    }
                    .padding(.trailing, DesignSpacing.md)
                    .padding(.top, 16)
                }
                
                ScrollView {
                    VStack(spacing: 32) {
                        Spacer()
                            .frame(height: 40)
                        
                        // Success Icon
                        ZStack {
                            Circle()
                                .fill(ArotiColor.accent.opacity(0.2))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(ArotiColor.accent)
                                .font(.system(size: 60))
                        }
                        
                        // Confirmation Message
                        VStack(spacing: 8) {
                            Text("Booking Confirmed!")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("Your session with \(specialist.name) is scheduled")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, DesignSpacing.md)
                        
                        // Booking Details Card
                        BaseCard {
                            VStack(alignment: .leading, spacing: 20) {
                                // Specialist Info
                                HStack(spacing: 12) {
                                    RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                        .fill(ArotiColor.accent.opacity(0.2))
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Text(specialist.name.prefix(2).uppercased())
                                                .font(DesignTypography.title2Font(weight: .semibold))
                                                .foregroundColor(ArotiColor.accent)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(specialist.name)
                                            .font(DesignTypography.headlineFont(weight: .semibold))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Text(specialist.specialty)
                                            .font(DesignTypography.subheadFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(ArotiColor.accent)
                                                .font(.system(size: 12))
                                            
                                            Text(String(format: "%.1f", specialist.rating))
                                                .font(DesignTypography.subheadFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                        }
                                    }
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                
                                // Session Details
                                VStack(spacing: 12) {
                                    SummaryRow(label: "Date", value: formatDate(selectedDate))
                                    SummaryRow(label: "Time", value: formatTime(selectedTime))
                                    SummaryRow(label: "Duration", value: "60 min")
                                    SummaryRow(label: "Price", value: "$\(specialist.price)")
                                }
                            }
                        }
                        .padding(.horizontal, DesignSpacing.md)
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            ArotiButton(
                                kind: .custom(.accentCard()),
                                title: "View Session Details",
                                action: {
                                    // Navigate to session details
                                }
                            )
                            
                            ArotiButton(
                                kind: .custom(.glassCardButton()),
                                title: "Back to Home",
                                action: {
                                    navigateToHome = true
                                }
                            )
                        }
                        .padding(.horizontal, DesignSpacing.md)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $navigateToHome) {
            // This will be handled by the parent navigation
            EmptyView()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
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

