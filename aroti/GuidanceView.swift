//
//  GuidanceView.swift
//  Aroti
//
//  Guidance experience mirroring the React page
//

import SwiftUI
import UIKit

private enum GuidanceScreen {
    case overview
    case chat
    case points
    case history
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

private struct GuidanceSession: Identifiable, Hashable {
    let id = UUID()
    let specialist: GuidanceSpecialist
    var title: String
    let dateLabel: String
    let preview: String
    var isArchived: Bool = false
    
    static let mock: [GuidanceSession] = [
        GuidanceSession(
            specialist: .astrologer,
            title: "Aroti • Daily Focus",
            dateLabel: "Oct 12",
            preview: "Let's tune into your energy together..."
        ),
        GuidanceSession(
            specialist: .therapist,
            title: "Elyon • Finding Calm",
            dateLabel: "Oct 5",
            preview: "How are you feeling in this moment?"
        ),
        GuidanceSession(
            specialist: .numerologist,
            title: "Orin • Life Path Insight",
            dateLabel: "Sept 29",
            preview: "The numbers show a powerful pattern..."
        ),
    ]
}

private enum GuidanceSpecialist: String, CaseIterable, Identifiable {
    case astrologer
    case therapist
    case numerologist
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .astrologer: return "Aroti"
        case .therapist: return "Elyon"
        case .numerologist: return "Orin"
        }
    }
    
    var description: String {
        switch self {
        case .astrologer: return "Cosmic insights & astrology guidance"
        case .therapist: return "Mindful support & emotional guidance"
        case .numerologist: return "Life path clarity & numerology"
        }
    }
    
    var iconName: String {
        switch self {
        case .astrologer: return "sparkles"
        case .therapist: return "heart.fill"
        case .numerologist: return "number"
        }
    }
    
    var costPerMessage: Int {
        switch self {
        case .astrologer, .numerologist: return 5
        case .therapist: return 10
        }
    }
    
    var gradient: [Color] {
        switch self {
        case .astrologer:
            return [DesignColors.primary, DesignColors.secondary]
        case .therapist:
            return [DesignColors.accent, DesignColors.accent.opacity(0.7)]
        case .numerologist:
            return [DesignColors.primary.opacity(0.9), DesignColors.secondary.opacity(0.8)]
        }
    }
    
    var welcomeMessage: String {
        switch self {
        case .astrologer:
            return "Hello! I'm Aroti, your cosmic guide. I can help you understand your astrological chart, daily energy, and life timing. What would you like to explore?"
        case .therapist:
            return "Hi there! I'm Elyon, here to offer mindful support and gentle guidance. How are you feeling today?"
        case .numerologist:
            return "Welcome! I'm Orin, a numbers mystic. I can help decode the patterns in your life path. What would you like to discover?"
        }
    }
    
    var suggestions: [String] {
        switch self {
        case .astrologer:
            return [
                "What's my energy today?",
                "Tell me about my chart",
                "What should I focus on this week?",
            ]
        case .therapist:
            return [
                "I'm feeling anxious",
                "Help me process my emotions",
                "I need guidance on a relationship",
            ]
        case .numerologist:
            return [
                "What's my life path number?",
                "What do my numbers reveal?",
                "Help me understand my destiny",
            ]
        }
    }
}

struct GuidanceView: View {
    @Binding var selectedTab: TabItem
    
    @State private var currentScreen: GuidanceScreen = .chat
    @State private var selectedSpecialist: GuidanceSpecialist = .astrologer
    @State private var userPoints: Int = 1240
    
    @State private var messages: [GuidanceMessage] = []
    @State private var inputText: String = ""
    @State private var isTyping: Bool = false
    
    @State private var showDisclaimer = false
    @State private var showMenuSheet = false
    
    @State private var sessions: [GuidanceSession] = GuidanceSession.mock
    @State private var sessionToRename: GuidanceSession?
    @State private var renameDraft: String = ""
    @State private var sessionToDelete: GuidanceSession?
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    CelestialBackground()
                    
                    VStack(spacing: 0) {
                        headerView
                        
                        Divider()
                            .overlay(Color.white.opacity(0.08))
                        
                        contentView
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        BottomNavigationBar(selectedTab: $selectedTab) { tab in
                            selectedTab = tab
                        }
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            ensureWelcomeMessage()
        }
        .sheet(isPresented: $showMenuSheet) {
            GuidanceMenuSheet(
                sessions: sessions,
                onResumeSession: { specialist in
                    startNewChat(for: specialist)
                    showMenuSheet = false
                },
                onShare: { session in
                    print("Share session \(session.id)")
                },
                onRename: { session in
                    sessionToRename = session
                    renameDraft = session.title
                    showMenuSheet = false
                },
                onArchive: { session in
                    archiveSession(session)
                },
                onDelete: { session in
                    sessionToDelete = session
                    showMenuSheet = false
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $sessionToRename) { session in
            RenameSessionSheet(
                title: $renameDraft,
                onCancel: {
                    sessionToRename = nil
                },
                onSave: {
                    renameSession(session, to: renameDraft)
                }
            )
        }
        .alert("Delete Session?", isPresented: Binding(
            get: { sessionToDelete != nil },
            set: { newValue in
                if !newValue {
                    sessionToDelete = nil
                }
            }
        )) {
            Button("Cancel", role: .cancel) {
                sessionToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let toDelete = sessionToDelete {
                    deleteSession(toDelete)
                }
            }
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $showDisclaimer) {
            DisclaimerSheet {
                showDisclaimer = false
            }
            .presentationDetents([.medium])
        }
    }
}

// MARK: - Rendering
private extension GuidanceView {
    var headerView: some View {
        switch currentScreen {
        case .chat:
            return AnyView(
                BaseHeader(
                    title: "Guidance",
                    subtitle: "Each insight costs \(selectedSpecialist.costPerMessage) pts",
                    leftAction: .init(
                        icon: Image(systemName: "line.3.horizontal"),
                        label: "Open menu",
                        action: { showMenuSheet = true }
                    ),
                    rightView: AnyView(
                        HStack(spacing: 8) {
                            // New Chat Button - Chip Style
                            Button(action: { startNewChat(for: selectedSpecialist) }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 12, weight: .medium))
                                    Text("New Chat")
                                        .font(DesignTypography.caption1Font(weight: .semibold))
                                }
                                .foregroundColor(DesignColors.primary)
                                .lineLimit(1)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(DesignColors.primary.opacity(0.15))
                                        .overlay(
                                            Capsule()
                                                .stroke(DesignColors.primary.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            
                            // Points Display - Chip Style
                            Button(action: { currentScreen = .points }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 10))
                                    Text("\(userPoints)")
                                        .font(DesignTypography.caption1Font(weight: .semibold))
                                }
                                .foregroundColor(DesignColors.accent)
                                .lineLimit(1)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(DesignColors.accent.opacity(0.15))
                                        .overlay(
                                            Capsule()
                                                .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                    )
                )
            )
        case .overview:
            return AnyView(
                BaseHeader(
                    title: "Guidance",
                    subtitle: "Personal AI guidance tailored to your journey",
                    leftAction: .init(
                        icon: Image(systemName: "chevron.left"),
                        label: "Back to chat",
                        action: { currentScreen = .chat }
                    ),
                    rightAction: .init(
                        icon: Image(systemName: "star.fill"),
                        label: "View points",
                        action: { currentScreen = .points }
                    )
                )
            )
        case .points:
            return AnyView(
                BaseHeader(
                    title: "Your Balance",
                    subtitle: "Track and earn points",
                    leftAction: .init(
                        icon: Image(systemName: "chevron.left"),
                        label: "Back",
                        action: { currentScreen = .chat }
                    )
                )
            )
        case .history:
            return AnyView(
                BaseHeader(
                    title: "Your Past Guidance",
                    subtitle: "Continue where you left off",
                    leftAction: .init(
                        icon: Image(systemName: "chevron.left"),
                        label: "Back",
                        action: { currentScreen = .chat }
                    )
                )
            )
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch currentScreen {
        case .chat:
            GuidanceChatScreen(
                specialist: selectedSpecialist,
                messages: messages,
                inputText: $inputText,
                isTyping: isTyping,
                onSend: sendMessage,
                onSuggestionTap: { inputText = $0 },
                onShowDisclaimer: { showDisclaimer = true }
            )
        case .overview:
            GuidanceOverviewScreen(
                userPoints: userPoints,
                onSelect: { specialist in
                    startNewChat(for: specialist)
                    currentScreen = .chat
                },
                onViewHistory: { currentScreen = .history },
                onViewPoints: { currentScreen = .points }
            )
        case .points:
            GuidancePointsScreen(userPoints: userPoints)
        case .history:
            GuidanceHistoryScreen(
                sessions: sessions,
                onResume: { specialist in
                    currentScreen = .chat
                    startNewChat(for: specialist)
                },
                onShare: { session in
                    print("Share session \(session.id)")
                },
                onRename: { session in
                    sessionToRename = session
                    renameDraft = session.title
                },
                onArchive: { session in
                    archiveSession(session)
                },
                onDelete: { session in
                    sessionToDelete = session
                }
            )
        }
    }
}

// MARK: - Actions
private extension GuidanceView {
    func ensureWelcomeMessage() {
        guard messages.isEmpty else { return }
        messages = [
            GuidanceMessage(
                role: .assistant,
                content: selectedSpecialist.welcomeMessage,
                timestamp: Date()
            ),
        ]
    }
    
    func startNewChat(for specialist: GuidanceSpecialist) {
        selectedSpecialist = specialist
        inputText = ""
        isTyping = false
        messages = [
            GuidanceMessage(
                role: .assistant,
                content: specialist.welcomeMessage,
                timestamp: Date()
            ),
        ]
    }
    
    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let userMessage = GuidanceMessage(role: .user, content: trimmed, timestamp: Date())
        messages.append(userMessage)
        inputText = ""
        isTyping = true
        
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
    
    func renameSession(_ session: GuidanceSession, to newName: String) {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        sessions = sessions.map { current in
            guard current.id == session.id else { return current }
            var updated = current
            updated.title = trimmed
            return updated
        }
        sessionToRename = nil
    }
    
    func archiveSession(_ session: GuidanceSession) {
        sessions = sessions.map { current in
            guard current.id == session.id else { return current }
            var updated = current
            updated.isArchived.toggle()
            return updated
        }
    }
    
    func deleteSession(_ session: GuidanceSession) {
        sessions.removeAll { $0.id == session.id }
        sessionToDelete = nil
    }
}

// MARK: - Chat Screen
private struct GuidanceChatScreen: View {
    let specialist: GuidanceSpecialist
    let messages: [GuidanceMessage]
    @Binding var inputText: String
    let isTyping: Bool
    let onSend: () -> Void
    let onSuggestionTap: (String) -> Void
    let onShowDisclaimer: () -> Void
    
    @FocusState private var isInputFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(messages) { message in
                            GuidanceBubble(message: message, onDisclaimer: onShowDisclaimer)
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
                    .padding(.horizontal, DesignSpacing.md)
                    .padding(.top, DesignSpacing.md)
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
                placeholder: "Ask \(specialist.name)...",
                text: $inputText,
                suggestions: messages.count <= 1 ? specialist.suggestions : [],
                onSuggestionTap: onSuggestionTap,
                onSend: onSend,
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
            .padding(.bottom, keyboardHeight)
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
    let onDisclaimer: () -> Void
    
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
        VStack(alignment: .leading, spacing: 8) {
            Text(message.content)
                .font(DesignTypography.bodyFont())
                .foregroundColor(message.role == .assistant ? DesignColors.foreground : Color.white)
            
            if message.role == .assistant {
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
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 12) {
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
                    .padding(.horizontal, DesignSpacing.md)
                }
            }
            
            HStack(spacing: 12) {
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
                
                Button(action: onSend) {
                    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    Image(systemName: trimmed.isEmpty ? "mic.fill" : "paperplane.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(trimmed.isEmpty ? DesignColors.mutedForeground : Color.white)
                        .frame(width: 44, height: 44)
                        .background {
                            if trimmed.isEmpty {
                                Circle()
                                    .fill(Color.white.opacity(0.08))
                            } else {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [DesignColors.primary, DesignColors.secondary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                        }
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            )
            .padding(.horizontal, DesignSpacing.md)
            .padding(.bottom, 8)
        }
    }
}

// MARK: - Overview
private struct GuidanceOverviewScreen: View {
    let userPoints: Int
    let onSelect: (GuidanceSpecialist) -> Void
    let onViewHistory: () -> Void
    let onViewPoints: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Start Your Journey")
                        .font(DesignTypography.title2Font(weight: .bold))
                        .foregroundColor(DesignColors.foreground)
                    Text("Connect with AI specialists who understand your unique path. Get personalized guidance whenever you need it.")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, DesignSpacing.md)
                
                ForEach(GuidanceSpecialist.allCases) { specialist in
                    BaseCard(variant: .interactive, action: {
                        onSelect(specialist)
                    }) {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: specialist.gradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Image(systemName: specialist.iconName)
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(specialist.name)
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                Text(specialist.description)
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("\(specialist.costPerMessage) pts")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                                    .foregroundColor(DesignColors.primary)
                                Text("per message")
                                    .font(DesignTypography.caption2Font())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                    }
                }
                
                Button(action: onViewHistory) {
                    Label("View Past Sessions", systemImage: "clock.fill")
                        .font(DesignTypography.subheadFont(weight: .semibold))
                        .foregroundColor(DesignColors.primary)
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
                        Text("Each message costs 5–10 points depending on your specialist.")
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

// MARK: - History
private struct GuidanceHistoryScreen: View {
    let sessions: [GuidanceSession]
    let onResume: (GuidanceSpecialist) -> Void
    let onShare: (GuidanceSession) -> Void
    let onRename: (GuidanceSession) -> Void
    let onArchive: (GuidanceSession) -> Void
    let onDelete: (GuidanceSession) -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if sessions.isEmpty {
                    BaseCard {
                        VStack(spacing: 16) {
                            Image(systemName: "message.circle")
                                .font(.system(size: 48))
                                .foregroundColor(DesignColors.mutedForeground)
                            Text("No past sessions yet — start your first conversation.")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                            ArotiButton(kind: .secondary, title: "Start New Chat", action: {})
                        }
                    }
                } else {
                    ForEach(sessions) { session in
                        BaseCard {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(session.title)
                                            .font(DesignTypography.subheadFont(weight: .semibold))
                                            .foregroundColor(session.isArchived ? DesignColors.mutedForeground : DesignColors.foreground)
                                            .lineLimit(1)
                                        Text("\"\(session.preview)\"")
                                            .font(DesignTypography.caption1Font())
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    Menu {
                                        Button("Share", systemImage: "square.and.arrow.up") {
                                            onShare(session)
                                        }
                                        Button("Rename", systemImage: "pencil") {
                                            onRename(session)
                                        }
                                        Button(session.isArchived ? "Unarchive" : "Archive", systemImage: "archivebox") {
                                            onArchive(session)
                                        }
                                        Divider()
                                        Button("Delete", systemImage: "trash", role: .destructive) {
                                            onDelete(session)
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .padding(4)
                                    }
                                }
                                
                                HStack {
                                    Text(session.dateLabel)
                                        .font(DesignTypography.caption2Font())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    Spacer()
                                    Button(action: { onResume(session.specialist) }) {
                                        Label("Resume", systemImage: "arrow.forward.circle.fill")
                                            .font(DesignTypography.caption1Font(weight: .medium))
                                            .foregroundColor(DesignColors.primary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, DesignSpacing.md)
            .padding(.bottom, 160)
        }
    }
}

// MARK: - Sheets
private struct GuidanceMenuSheet: View {
    let sessions: [GuidanceSession]
    let onResumeSession: (GuidanceSpecialist) -> Void
    let onShare: (GuidanceSession) -> Void
    let onRename: (GuidanceSession) -> Void
    let onArchive: (GuidanceSession) -> Void
    let onDelete: (GuidanceSession) -> Void
    
    @State private var searchText: String = ""
    
    private var filteredSessions: [GuidanceSession] {
        if searchText.isEmpty {
            return sessions
        }
        return sessions.filter { session in
            session.title.localizedCaseInsensitiveContains(searchText) ||
            session.preview.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                VStack(spacing: 0) {
                    // Top Section: Search Only
                    VStack(spacing: 16) {
                        // Search Bar
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16))
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            ZStack(alignment: .leading) {
                                if searchText.isEmpty {
                                    Text("Search chats...")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                                        .padding(.horizontal, 4)
                                }
                                TextField("", text: $searchText)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal, DesignSpacing.md)
                    .padding(.top, DesignSpacing.md)
                    .padding(.bottom, DesignSpacing.sm)
                    
                    Divider()
                        .background(Color.white.opacity(0.08))
                    
                    // History Section
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            // HISTORY Label
                            Text("HISTORY")
                                .font(DesignTypography.caption1Font(weight: .bold))
                                .foregroundColor(DesignColors.mutedForeground)
                                .tracking(1.5)
                                .padding(.horizontal, DesignSpacing.md)
                                .padding(.top, DesignSpacing.md)
                            
                            // Chat Sessions List
                            if filteredSessions.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "message.circle")
                                        .font(.system(size: 48))
                                        .foregroundColor(DesignColors.mutedForeground.opacity(0.5))
                                    Text(searchText.isEmpty ? "No past sessions yet" : "No results found")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, DesignSpacing.xl)
                            } else {
                                ForEach(filteredSessions) { session in
                                    GuidanceHistoryItem(
                                        session: session,
                                        onResume: { onResumeSession(session.specialist) },
                                        onShare: { onShare(session) },
                                        onRename: { onRename(session) },
                                        onArchive: { onArchive(session) },
                                        onDelete: { onDelete(session) }
                                    )
                                    .padding(.horizontal, DesignSpacing.md)
                                }
                            }
                        }
                        .padding(.bottom, DesignSpacing.lg)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// History item component with 3-dot menu
private struct GuidanceHistoryItem: View {
    let session: GuidanceSession
    let onResume: () -> Void
    let onShare: () -> Void
    let onRename: () -> Void
    let onArchive: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Content - tappable to resume
            Button(action: onResume) {
                VStack(alignment: .leading, spacing: 6) {
                    // Title
                    Text(session.title)
                        .font(DesignTypography.subheadFont(weight: .semibold))
                        .foregroundColor(session.isArchived ? DesignColors.mutedForeground : DesignColors.foreground)
                        .lineLimit(1)
                    
                    // Preview text
                    Text("\"\(session.preview)\"")
                        .font(DesignTypography.caption1Font())
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Date and Menu
            HStack(spacing: 12) {
                Text(session.dateLabel)
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground)
                
                // 3-dot menu
                Menu {
                    Button("Share", systemImage: "square.and.arrow.up") {
                        onShare()
                    }
                    Button("Rename", systemImage: "pencil") {
                        onRename()
                    }
                    Button(session.isArchived ? "Unarchive" : "Archive", systemImage: "archivebox") {
                        onArchive()
                    }
                    Divider()
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        onDelete()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DesignColors.mutedForeground)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.05))
                        )
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.03))
        )
    }
}

private struct RenameSessionSheet: View {
    @Binding var title: String
    let onCancel: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Rename Session")
                    .font(DesignTypography.title3Font(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                TextField("Session name", text: $title)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                HStack {
                    Button("Cancel", action: onCancel)
                        .buttonStyle(.bordered)
                    Spacer()
                    Button("Save", action: onSave)
                        .buttonStyle(.borderedProminent)
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.top, 32)
        }
    }
}

private struct DisclaimerSheet: View {
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Disclaimer")
                    .font(DesignTypography.title3Font(weight: .bold))
                    .foregroundColor(DesignColors.foreground)
                Text("AI responses are generated by artificial intelligence and may not always be accurate. Please use your judgment and consult with qualified professionals for important decisions.")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                Text("Responses may vary and should not be considered definitive advice. The information provided is for guidance purposes only and does not replace professional consultation.")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                Spacer()
                Button("Close", action: onDismiss)
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
            }
            .padding(24)
        }
    }
}

#Preview {
    GuidanceView(selectedTab: .constant(.guidance))
}

