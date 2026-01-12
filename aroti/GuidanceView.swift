//
//  GuidanceView.swift
//  Aroti
//
//  Guidance experience mirroring the React page
//

import SwiftUI
import UIKit

private enum GuidanceLayout {
    static let horizontalPadding: CGFloat = DesignSpacing.sm
}

private enum GuidanceScreen {
    case overview
    case chat
    case points
}

private struct GuidanceMessage: Identifiable, Equatable {
    enum Role {
        case user
        case assistant
    }
    
    let id = UUID()
    let role: Role
    let content: String
    let timestamp: Date
}


// Aroti guidance constants
private struct ArotiGuidance {
    static let welcomeMessage = "Hello! I'm Aroti, your cosmic guide.\n\nI can help you understand your astrological chart, daily energy, and life timing.\n\nWhat would you like to explore?"
    
    static let suggestions = [
        "What's my energy today?",
        "Tell me about my chart",
        "What should I focus on this week?",
    ]
}

struct GuidanceView: View {
    @Binding var selectedTab: TabItem
    
    @State private var currentScreen: GuidanceScreen = .chat
    @State private var userPoints: Int = 1240
    
    @State private var messages: [GuidanceMessage] = []
    @State private var inputText: String = ""
    @State private var isTyping: Bool = false
    
    @State private var showDisclaimer = false
    @State private var showPointsSpendModal = false
    @State private var showConversationStarters = false
    @State private var pendingMessage: String = ""
    @State private var currentChatId: UUID = UUID()
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let safeAreaTop = geometry.safeAreaInsets.top
                
                ZStack(alignment: .bottom) {
                    CelestialBackground()
                        .ignoresSafeArea()
                    
                    ZStack(alignment: .top) {
                        contentView
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 32) // Header content height
                            .padding(.bottom, 60) // Space for bottom nav
                        
                        headerView(safeAreaTop: safeAreaTop)
                    }
                    
                    // Bottom Navigation Bar
                    VStack {
                        Spacer()
                        BottomNavigationBar(selectedTab: $selectedTab) { tab in
                            selectedTab = tab
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
                .navigationBarHidden(true)
            }
        }
        .onAppear {
            ensureWelcomeMessage()
            updatePointsBalance()
            
            // Testing helpers - refill free messages and add points
            #if DEBUG
            AccessControlService.shared.resetFreeMessagesForTesting()
            PointsService.shared.addPointsForTesting(1000)
            updatePointsBalance()
            #endif
        }
        .sheet(isPresented: $showPointsSpendModal) {
            let balance = PointsService.shared.getBalance()
            let (_, cost) = AccessControlService.shared.canAccessAIChat()
            PointsSpendModal(
                isPresented: $showPointsSpendModal,
                cost: cost ?? 20,
                currentBalance: balance.totalPoints,
                title: "Unlock AI Message",
                message: "This message costs \(cost ?? 20) points. Continue?",
                onConfirm: {
                    handlePointsSpendForMessage()
                },
                onUpgrade: {
                    // Navigate to premium upgrade
                    print("Navigate to premium upgrade")
                }
            )
        }
        .sheet(isPresented: $showDisclaimer) {
            DisclaimerSheet {
                showDisclaimer = false
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showConversationStarters) {
            ConversationStartersModal(
                onDismiss: { showConversationStarters = false },
                onSelectStarter: { starter in
                    showConversationStarters = false
                    startNewChatWithStarter(starter)
                },
                onSelectFreeTopic: {
                    showConversationStarters = false
                    startNewChatFreeTopic()
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Rendering
private extension GuidanceView {
    @ViewBuilder
    func headerView(safeAreaTop: CGFloat) -> some View {
        switch currentScreen {
        case .chat:
            StickyHeaderBar(
                title: "Guidance",
                subtitle: computeSubtitle(),
                safeAreaTop: safeAreaTop
            ) {
                HStack(spacing: 8) {
                    // Points Chip - dynamic width based on content
                    NavigationLink(destination: JourneyPage()) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                            Text("\(userPoints.formatted())")
                                .font(DesignTypography.caption1Font(weight: .semibold))
                        }
                        .foregroundColor(DesignColors.accent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .frame(height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Notification Bell - matching points style
                    Button(action: {
                        // Handle notification tap
                    }) {
                        Image(systemName: "bell")
                            .font(.system(size: 16))
                            .foregroundColor(DesignColors.accent)
                            .frame(width: 36, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.06))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                            )
                    }
                }
            }
        case .overview:
            StickyHeaderBar(
                title: "Guidance",
                subtitle: "Personal AI guidance tailored to your journey",
                safeAreaTop: safeAreaTop,
                leftAction: .init(
                    iconName: "chevron.left",
                    accessibilityLabel: "Back to chat",
                    action: { currentScreen = .chat }
                )
            ) {
                NavigationLink(destination: JourneyPage()) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 18))
                        .foregroundColor(DesignColors.accent)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(DesignColors.accent.opacity(0.15))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        case .points:
            StickyHeaderBar(
                title: "Your Balance",
                subtitle: "Track and earn points",
                safeAreaTop: safeAreaTop,
                leftAction: .init(
                    iconName: "chevron.left",
                    accessibilityLabel: "Back",
                    action: { currentScreen = .chat }
                )
            )
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch currentScreen {
        case .chat:
            GuidanceChatScreen(
                messages: messages,
                inputText: $inputText,
                isTyping: isTyping,
                onSend: sendMessage,
                onSuggestionTap: { inputText = $0 },
                onShowDisclaimer: { showDisclaimer = true },
                onPlusTap: { showConversationStarters = true },
                onShowToast: { message in
                    toastMessage = message
                    showToast = true
                }
            )
            .toast(isPresented: $showToast, message: toastMessage)
        case .overview:
            GuidanceOverviewScreen(
                userPoints: userPoints,
                onStartChat: {
                    startNewChat()
                    currentScreen = .chat
                },
                onViewPoints: { currentScreen = .points }
            )
        case .points:
            GuidancePointsScreen(userPoints: userPoints)
        }
    }
}

// MARK: - Actions
private extension GuidanceView {
    func computeSubtitle() -> String {
        if AccessControlService.shared.isPremium {
            return "Unlimited messages"
        }
        let remaining = AccessControlService.shared.getFreeMessagesRemaining()
        return "\(remaining) free messages/day, then 20 pts each"
    }
    
    func ensureWelcomeMessage() {
        guard messages.isEmpty else { return }
        messages = [
            GuidanceMessage(
                role: .assistant,
                content: ArotiGuidance.welcomeMessage,
                timestamp: Date()
            ),
        ]
    }
    
    func startNewChat() {
        inputText = ""
        isTyping = false
        currentChatId = UUID()
        messages = [
            GuidanceMessage(
                role: .assistant,
                content: ArotiGuidance.welcomeMessage,
                timestamp: Date()
            ),
        ]
    }
    
    func startNewChatWithStarter(_ starter: String) {
        currentChatId = UUID()
        messages = [
            GuidanceMessage(
                role: .assistant,
                content: ArotiGuidance.welcomeMessage,
                timestamp: Date()
            ),
        ]
        inputText = starter
        isTyping = false
        // Auto-send the starter
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sendMessage()
        }
    }
    
    func startNewChatFreeTopic() {
        currentChatId = UUID()
        messages = [
            GuidanceMessage(
                role: .assistant,
                content: ArotiGuidance.welcomeMessage,
                timestamp: Date()
            ),
        ]
        inputText = ""
        isTyping = false
        // Focus will be handled by the input bar
        // Note: Input focus should be set after a brief delay to ensure view is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Focus is handled by the input bar's FocusState
        }
    }
    
    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // Check access control
        let (allowed, cost) = AccessControlService.shared.canAccessAIChat()
        
        if !allowed {
            // Need to spend points or upgrade
            if let cost = cost {
                let balance = PointsService.shared.getBalance()
                if balance.totalPoints >= cost {
                    // Show confirmation modal
                    pendingMessage = trimmed
                    showPointsSpendModal = true
                } else {
                    // Not enough points - show upgrade modal
                    pendingMessage = trimmed
                    showPointsSpendModal = true
                }
            } else {
                // Premium only - show upgrade prompt
                pendingMessage = trimmed
                showPointsSpendModal = true
            }
            return
        }
        
        // Free or premium - send message
        actuallySendMessage(trimmed)
    }
    
    private func handlePointsSpendForMessage() {
        let (_, cost) = AccessControlService.shared.canAccessAIChat()
        guard let cost = cost else { return }
        
        let result = PointsService.shared.spendPoints(event: "ai_chat_message", cost: cost)
        
        if result.success {
            actuallySendMessage(pendingMessage)
            pendingMessage = ""
            updatePointsBalance()
        }
    }
    
    private func actuallySendMessage(_ text: String) {
        let userMessage = GuidanceMessage(role: .user, content: text, timestamp: Date())
        messages.append(userMessage)
        inputText = ""
        isTyping = true
        
        // Record message usage
        AccessControlService.shared.recordAIChatMessage()
        
        // Update points balance and subtitle will auto-update via computeSubtitle()
        updatePointsBalance()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let response = GuidanceMessage(
                role: .assistant,
                content: "I understand. Let's explore this further together. Can you share a little more about how this feels for you?",
                timestamp: Date()
            )
            messages.append(response)
            isTyping = false
        }
    }
    
    private func updatePointsBalance() {
        let balance = PointsService.shared.getBalance()
        userPoints = balance.totalPoints
    }
}

// MARK: - Chat Screen
private struct GuidanceChatScreen: View {
    let messages: [GuidanceMessage]
    @Binding var inputText: String
    let isTyping: Bool
    let onSend: () -> Void
    let onSuggestionTap: (String) -> Void
    let onShowDisclaimer: () -> Void
    let onPlusTap: () -> Void
    let onShowToast: (String) -> Void
    
    @FocusState private var isInputFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
                            GuidanceBubble(
                                message: message,
                                isWelcomeMessage: message.role == .assistant && index == 0,
                                onDisclaimer: onShowDisclaimer,
                                onShowToast: onShowToast
                            )
                            .id(message.id)
                        }
                        
                        if isTyping {
                            TypingIndicator()
                                .id("typing-indicator")
                        }
                        
                        // Fixed bottom spacer - always present for consistent padding above input bar
                        // Height accounts for input bar (~60px) + minimal padding (8px)
                        Color.clear
                            .frame(height: 68)
                            .id("bottom-spacer")
                    }
                    .padding(.horizontal, GuidanceLayout.horizontalPadding)
                    .padding(.top, DesignSpacing.lg + 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: messages.count) { oldCount, newCount in
                    // Only auto-scroll if we're adding a new message (not removing)
                    if newCount > oldCount {
                        // Use immediate scroll with smooth animation - no delay for better UX
                        withAnimation(.easeOut(duration: 0.35)) {
                            proxy.scrollTo("bottom-spacer", anchor: .bottom)
                        }
                    }
                }
                .onChange(of: isTyping) { _, newValue in
                    // Scroll smoothly when typing indicator appears
                    if newValue {
                        withAnimation(.easeOut(duration: 0.35)) {
                            proxy.scrollTo("typing-indicator", anchor: .bottom)
                        }
                    }
                }
                .onTapGesture {
                    // Dismiss keyboard when tapping outside
                    isInputFocused = false
                }
            }
            
            // Input bar - positioned above keyboard with minimal padding
            GuidanceInputBar(
                placeholder: "Ask Aroti…",
                text: $inputText,
                suggestions: messages.count <= 1 ? ArotiGuidance.suggestions : [],
                onSuggestionTap: onSuggestionTap,
                onSend: onSend,
                onPlusTap: onPlusTap,
                isFocused: $isInputFocused
            )
            .background(
                LinearGradient(
                    colors: [
                        Color(hue: 240/360, saturation: 0.30, brightness: 0.09),
                        ArotiColor.bg,
                        ArotiColor.bg.opacity(0.4),
                        .clear,
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .padding(.bottom, keyboardHeight + 60) // 60px for bottom nav bar
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeOut(duration: 0.25)) {
                    // Use minimal padding - just enough to keep input visible
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
                    keyboardHeight = keyboardFrame.height - safeAreaBottom
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeOut(duration: 0.25)) {
                keyboardHeight = 0
            }
        }
    }
}

// MARK: - Bubbles
private struct GuidanceBubble: View {
    let message: GuidanceMessage
    let isWelcomeMessage: Bool
    let onDisclaimer: () -> Void
    let onShowToast: (String) -> Void
    
    @State private var thumbsUpActive = false
    @State private var thumbsDownActive = false
    
    var body: some View {
        HStack {
            if message.role == .assistant {
                bubble
                Spacer(minLength: 40)
            } else {
                Spacer(minLength: 40)
                bubble
            }
        }
        .transition(.opacity.combined(with: .move(edge: message.role == .assistant ? .leading : .trailing)))
    }
    
    private var bubble: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Message bubble content
            VStack(alignment: .leading, spacing: isWelcomeMessage ? 12 : 8) {
                if isWelcomeMessage {
                    // Formatted welcome message with better spacing and readability
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(message.content.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                            if !paragraph.isEmpty {
                                Text(paragraph)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                                    .lineSpacing(4)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                } else {
                    Text(message.content)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(message.role == .assistant ? DesignColors.foreground : Color.white)
                }
                
                // Disclaimer button (only for non-welcome assistant messages)
                if message.role == .assistant && !isWelcomeMessage {
                    Button("Disclaimer", action: onDisclaimer)
                        .font(DesignTypography.caption2Font(weight: .medium))
                        .foregroundColor(DesignColors.accent)
                        .underline(true, color: DesignColors.accent)
                }
            }
            .padding(16)
            .background {
                if message.role == .assistant {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.94))
                } else {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [DesignColors.primary, DesignColors.secondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .stroke(message.role == .assistant ? Color.white.opacity(0.12) : Color.clear, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 2)
            
            // Action buttons row (outside bubble, only for non-welcome assistant messages)
            if message.role == .assistant && !isWelcomeMessage {
                HStack(spacing: 12) {
                    // Copy button
                    Button(action: {
                        HapticFeedback.impactOccurred(.light)
                        UIPasteboard.general.string = message.content
                        onShowToast("Copied to clipboard")
                    }) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(DesignColors.mutedForeground)
                            .frame(width: 44, height: 44)
                    }
                    
                    // Thumbs up button
                    Button(action: {
                        HapticFeedback.impactOccurred(.light)
                        if thumbsUpActive {
                            thumbsUpActive = false
                        } else {
                            thumbsUpActive = true
                            thumbsDownActive = false
                            onShowToast("Thanks for your feedback")
                        }
                    }) {
                        Image(systemName: thumbsUpActive ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(thumbsUpActive ? DesignColors.primary : DesignColors.mutedForeground)
                            .frame(width: 44, height: 44)
                    }
                    
                    // Thumbs down button
                    Button(action: {
                        HapticFeedback.impactOccurred(.light)
                        if thumbsDownActive {
                            thumbsDownActive = false
                        } else {
                            thumbsDownActive = true
                            thumbsUpActive = false
                            onShowToast("Thanks for your feedback")
                        }
                    }) {
                        Image(systemName: thumbsDownActive ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(thumbsDownActive ? DesignColors.primary : DesignColors.mutedForeground)
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                }
                .padding(.top, 8)
            }
        }
    }
}

private struct TypingIndicator: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Circle().fill(DesignColors.primary).frame(width: 8, height: 8)
                    Circle().fill(DesignColors.primary).frame(width: 8, height: 8).opacity(0.7)
                    Circle().fill(DesignColors.primary).frame(width: 8, height: 8).opacity(0.4)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.92))
            )
            Spacer()
        }
    }
}

// MARK: - Input Bar
private struct GuidanceInputBar: View {
    let placeholder: String
    @Binding var text: String
    let suggestions: [String]
    let onSuggestionTap: (String) -> Void
    let onSend: () -> Void
    let onPlusTap: () -> Void
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Suggestion chips row - shown initially (when messages.count <= 1)
            if !suggestions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(action: { onSuggestionTap(suggestion) }) {
                                Text(suggestion)
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.foreground)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.06))
                                    )
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, GuidanceLayout.horizontalPadding)
                }
            }
            
            // Oura-style bottom bar: Plus button (separate) + Input box + Send/Mic
            HStack(spacing: 12) {
                // Left: Circular plus button (separate, not inside input box)
                Button(action: {
                    HapticFeedback.impactOccurred(.medium)
                    onPlusTap()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.08))
                        )
                }
                
                // Center: Input box container (input field + send/mic button)
                HStack(spacing: 12) {
                    // Wide input field
                    ZStack(alignment: .leading) {
                        if text.isEmpty {
                            Text(placeholder)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                                .padding(.horizontal, 4)
                        }
                        TextField("", text: $text, axis: .vertical)
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                            .lineLimit(1...3)
                            .focused($isFocused)
                    }
                    
                    // Right: Send arrow button
                    Button(action: {
                        HapticFeedback.impactOccurred(.light)
                        onSend()
                    }) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [DesignColors.primary, DesignColors.secondary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                    }
                }
                .padding(.vertical, 0)
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.95))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )
            }
            .padding(.horizontal, GuidanceLayout.horizontalPadding)
            .padding(.bottom, 8)
        }
    }
}

// MARK: - Overview
private struct GuidanceOverviewScreen: View {
    let userPoints: Int
    let onStartChat: () -> Void
    let onViewPoints: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Start Your Journey")
                        .font(DesignTypography.title2Font(weight: .bold))
                        .foregroundColor(DesignColors.foreground)
                    Text("Connect with Aroti for personalized guidance. Get cosmic insights and support whenever you need it.")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, DesignSpacing.md)
                
                BaseCard(variant: .interactive, action: {
                    onStartChat()
                }) {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [DesignColors.primary, DesignColors.secondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: "sparkles")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Aroti")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            Text("Cosmic insights & astrology guidance")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("20 pts")
                                .font(DesignTypography.subheadFont(weight: .semibold))
                                .foregroundColor(DesignColors.primary)
                            Text("per message")
                                .font(DesignTypography.caption2Font())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    }
                }
                
                Button(action: onViewPoints) {
                    Label("\(userPoints) points", systemImage: "star.fill")
                        .font(DesignTypography.subheadFont(weight: .bold))
                        .foregroundColor(DesignColors.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(DesignColors.secondary.opacity(0.2))
                        )
                }
            }
            .padding(.horizontal, DesignSpacing.md)
            .padding(.bottom, 140)
        }
    }
}

// MARK: - Points
private struct GuidancePointsScreen: View {
    struct EarnOption: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let points: String
        let description: String
    }
    
    let userPoints: Int
    
    private let options: [EarnOption] = [
        EarnOption(icon: "play.rectangle.fill", title: "Watch short lessons", points: "+10 pts", description: "Complete 5-minute mindful videos"),
        EarnOption(icon: "person.2.fill", title: "Invite a friend", points: "+50 pts", description: "Share Aroti with your circle"),
        EarnOption(icon: "crown.fill", title: "Upgrade to Premium", points: "Unlimited", description: "Unlimited messages & exclusive content"),
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                BaseCard {
                    VStack(spacing: 16) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [DesignColors.primary, DesignColors.secondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "star.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                            )
                        Text("\(userPoints.formatted()) Points")
                            .font(DesignTypography.title1Font(weight: .bold))
                            .foregroundColor(DesignColors.foreground)
                        Text("Each message costs 20 points.")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .multilineTextAlignment(.center)
                    }
                }
                
                VStack(spacing: 12) {
                    ForEach(options) { option in
                        BaseCard(variant: .interactive, action: {}) {
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [DesignColors.primary, DesignColors.secondary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 48, height: 48)
                                    .overlay(
                                        Image(systemName: option.icon)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.title)
                                        .font(DesignTypography.subheadFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    Text(option.description)
                                        .font(DesignTypography.caption1Font())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                
                                Spacer()
                                
                                Text(option.points)
                                    .font(DesignTypography.subheadFont(weight: .bold))
                                    .foregroundColor(DesignColors.primary)
                            }
                        }
                    }
                }
                
                ArotiButton(kind: .primary, title: "Get More Points", action: {})
            }
            .padding(.horizontal, DesignSpacing.md)
            .padding(.bottom, 140)
        }
    }
}


private struct DisclaimerSheet: View {
    @Environment(\.dismiss) var dismiss
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Disclaimer content
                        VStack(alignment: .leading, spacing: 16) {
                            Text("AI responses are generated by artificial intelligence and may not always be accurate. Please use your judgment and consult with qualified professionals for important decisions.")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.foreground)
                                .lineSpacing(4)
                            
                            Text("Responses may vary and should not be considered definitive advice. The information provided is for guidance purposes only and does not replace professional consultation.")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.foreground)
                                .lineSpacing(4)
                        }
                        .padding(.top, 8)
                        
                        // Close button
                        ArotiButton(
                            kind: .primary,
                            title: "Got it",
                            action: {
                                onDismiss()
                                dismiss()
                            }
                        )
                        .padding(.top, 8)
                    }
                    .padding(DesignSpacing.sm)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Disclaimer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                        dismiss()
                    }
                    .foregroundColor(DesignColors.accent)
                }
            }
        }
    }
}

#Preview {
    GuidanceView(selectedTab: .constant(.guidance))
}

