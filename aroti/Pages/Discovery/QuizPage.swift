//
//  QuizPage.swift
//  Aroti
//
//  Daily Quiz page matching React implementation
//

import SwiftUI

struct QuizQuestion: Identifiable {
    let id: Int
    let question: String
    let options: [String]
    let correctAnswer: Int
}

struct QuizData {
    static let questions: [QuizQuestion] = [
        QuizQuestion(
            id: 1,
            question: "What does the Fool card typically represent?",
            options: [
                "The end of a journey",
                "A new beginning or fresh start",
                "Wisdom and completion",
                "Challenges and obstacles"
            ],
            correctAnswer: 1
        ),
        QuizQuestion(
            id: 2,
            question: "How many cards are in the Major Arcana?",
            options: ["20", "21", "22", "24"],
            correctAnswer: 2
        ),
        QuizQuestion(
            id: 3,
            question: "What does reversed position of a card typically indicate?",
            options: [
                "The opposite meaning",
                "Blocked or internal energy",
                "A negative outcome",
                "The card should be ignored"
            ],
            correctAnswer: 1
        ),
        QuizQuestion(
            id: 4,
            question: "What is the Celtic Cross spread primarily used for?",
            options: [
                "Simple yes/no questions",
                "Comprehensive life guidance",
                "Love and relationships only",
                "Career questions only"
            ],
            correctAnswer: 1
        ),
        QuizQuestion(
            id: 5,
            question: "Which suit represents emotions and relationships?",
            options: ["Wands", "Cups", "Swords", "Pentacles"],
            correctAnswer: 1
        )
    ]
}

struct QuizPage: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestion = 0
    @State private var selectedAnswers: [Int: Int] = [:]
    @State private var showResults = false
    @State private var showAccessModal = false
    @State private var hasCheckedAccess = false
    
    private let questions = QuizData.questions
    
    private var currentQ: QuizQuestion {
        questions[currentQuestion]
    }
    
    private var selectedAnswer: Int? {
        selectedAnswers[currentQ.id]
    }
    
    private var score: Int {
        var correct = 0
        questions.forEach { q in
            if selectedAnswers[q.id] == q.correctAnswer {
                correct += 1
            }
        }
        return correct
    }
    
    private var percentage: Int {
        guard !questions.isEmpty else { return 0 }
        return Int(round(Double(score) / Double(questions.count) * 100))
    }
    
    private var pointsEarned: Int {
        score * 10 // 10 points per correct answer
    }
    
    private func getScoreMessage() -> String {
        if percentage >= 80 {
            return "Excellent! You're a tarot master!"
        } else if percentage >= 60 {
            return "Great job! Keep learning!"
        } else if percentage >= 40 {
            return "Good effort! Practice makes perfect!"
        } else {
            return "Keep studying! Every expert was once a beginner."
        }
    }
    
    private func handleAnswer(_ answerIndex: Int) {
        if showResults { return }
        
        selectedAnswers[currentQ.id] = answerIndex
        
        // Auto-advance to next question after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if currentQuestion < questions.count - 1 {
                currentQuestion += 1
            } else {
                showResults = true
                // Award points for completing quiz
                _ = PointsService.shared.earnPoints(event: "complete_quiz", points: 10)
                JourneyService.shared.recordActivity(type: "quiz", points: 10)
                AccessControlService.shared.recordQuiz()
                DailyStateManager.shared.checkAndAwardStreakBonus()
            }
        }
    }
    
    private var progressPercentage: Int {
        guard !questions.isEmpty else { return 0 }
        return Int(round(Double(currentQuestion + 1) / Double(questions.count) * 100))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        BaseHeader(
                            title: "Daily Quiz",
                            subtitle: "Test your tarot knowledge",
                            leftAction: BaseHeader.HeaderAction(
                                icon: Image(systemName: "chevron.left"),
                                label: "Back to Discovery",
                                action: { dismiss() }
                            )
                        )
                        .padding(.top, max(0, geometry.safeAreaInsets.top - 45))
                        
                        if !showResults {
                            quizInterfaceView
                        } else {
                            resultsView
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            checkAccess()
        }
        .sheet(isPresented: $showAccessModal) {
            let balance = PointsService.shared.getBalance()
            let (_, cost) = AccessControlService.shared.canAccessQuiz()
            PointsSpendModal(
                isPresented: $showAccessModal,
                cost: cost ?? 10,
                currentBalance: balance.totalPoints,
                title: "Unlock Quiz",
                message: "You've used your free quiz today. Unlock another for \(cost ?? 10) points?",
                onConfirm: {
                    handleUnlockQuiz()
                },
                onUpgrade: {
                    // Navigate to premium upgrade
                }
            )
        }
    }
    
    private func checkAccess() {
        let (allowed, _) = AccessControlService.shared.canAccessQuiz()
        if !allowed {
            showAccessModal = true
        }
    }
    
    private func handleUnlockQuiz() {
        let (_, cost) = AccessControlService.shared.canAccessQuiz()
        guard let cost = cost else { return }
        
        let result = PointsService.shared.spendPoints(event: "unlock_quiz", cost: cost)
        if result.success {
            AccessControlService.shared.recordQuiz()
        }
    }
    
    private var quizInterfaceView: some View {
        VStack(spacing: 16) {
            // Progress
            BaseCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Question \(currentQuestion + 1) of \(questions.count)")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        
                        Spacer()
                        
                        Text("\(progressPercentage)%")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 5)
                                .fill(
                                    LinearGradient(
                                        colors: [DesignColors.accent.opacity(0.6), DesignColors.accent],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: max(proxy.size.width * CGFloat(currentQuestion + 1) / CGFloat(questions.count), 0),
                                    height: 8
                                )
                        }
                    }
                    .frame(height: 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, DesignSpacing.sm)
            
            // Question
            BaseCard {
                VStack(alignment: .leading, spacing: 16) {
                    Text(currentQ.question)
                        .font(DesignTypography.title2Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    // Options
                    VStack(spacing: 12) {
                        ForEach(Array(currentQ.options.enumerated()), id: \.offset) { index, option in
                            QuizOptionButton(
                                option: option,
                                index: index,
                                isSelected: selectedAnswer == index,
                                isCorrect: index == currentQ.correctAnswer,
                                showCorrect: selectedAnswer != nil,
                                onTap: {
                                    handleAnswer(index)
                                }
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, DesignSpacing.sm)
        }
        .padding(.top, 16)
        .padding(.bottom, 60)
    }
    
    private var resultsView: some View {
        VStack(spacing: 16) {
            // Results Summary
            BaseCard {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(DesignColors.accent.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .stroke(DesignColors.accent.opacity(0.3), lineWidth: 2)
                            )
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 40))
                            .foregroundColor(DesignColors.accent)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Quiz Complete!")
                            .font(DesignTypography.title2Font(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text(getScoreMessage())
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .multilineTextAlignment(.center)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    HStack(spacing: 24) {
                        VStack(spacing: 4) {
                            Text("\(score)/\(questions.count)")
                                .font(DesignTypography.title1Font(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            Text("Correct")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 1, height: 48)
                        
                        VStack(spacing: 4) {
                            Text("\(percentage)%")
                                .font(DesignTypography.title1Font(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                            Text("Score")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 1, height: 48)
                        
                        VStack(spacing: 4) {
                            Text("+\(pointsEarned)")
                                .font(DesignTypography.title1Font(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                            Text("Points")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    }
                }
            }
            .padding(.horizontal, DesignSpacing.sm)
            
            // Review Section
            reviewSectionView
            
            // Actions
            HStack(spacing: 12) {
                Button(action: {
                    currentQuestion = 0
                    selectedAnswers = [:]
                    showResults = false
                }) {
                    Text("Retake Quiz")
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                }
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Back to Discovery")
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(DesignColors.accent)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(DesignColors.accent.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                )
                        )
                }
            }
            .padding(.horizontal, DesignSpacing.sm)
        }
        .padding(.top, 16)
        .padding(.bottom, 60)
    }
    
    private var reviewSectionView: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Review Your Answers")
                    .font(DesignTypography.title3Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                VStack(spacing: 16) {
                    ForEach(questions) { q in
                        QuestionReviewRow(
                            question: q,
                            selectedAnswer: selectedAnswers[q.id],
                            correctAnswer: q.correctAnswer
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, DesignSpacing.sm)
    }
}

struct QuizOptionButton: View {
    let option: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let showCorrect: Bool
    let onTap: () -> Void
    
    private var optionLetter: String {
        String(Character(UnicodeScalar(65 + index)!))
    }
    
    private var circleFill: Color {
        if isSelected && isCorrect {
            return DesignColors.accent.opacity(0.2)
        } else if isSelected && !isCorrect {
            return Color.red.opacity(0.2)
        } else {
            return Color.white.opacity(0.05)
        }
    }
    
    private var circleStroke: Color {
        if isSelected && isCorrect {
            return DesignColors.accent.opacity(0.3)
        } else if isSelected && !isCorrect {
            return Color.red.opacity(0.3)
        } else {
            return Color.white.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        if isSelected && isCorrect {
            return DesignColors.accent
        } else if isSelected && !isCorrect {
            return Color.red.opacity(0.8)
        } else {
            return DesignColors.foreground
        }
    }
    
    private var backgroundFill: Color {
        if showCorrect && !isSelected && isCorrect {
            return DesignColors.accent.opacity(0.1)
        } else if isSelected && isCorrect {
            return DesignColors.accent.opacity(0.2)
        } else if isSelected && !isCorrect {
            return Color.red.opacity(0.1)
        } else {
            return Color.white.opacity(0.05)
        }
    }
    
    private var strokeColor: Color {
        if showCorrect && !isSelected && isCorrect {
            return DesignColors.accent.opacity(0.5)
        } else if isSelected && isCorrect {
            return DesignColors.accent.opacity(0.5)
        } else if isSelected && !isCorrect {
            return Color.red.opacity(0.5)
        } else {
            return Color.white.opacity(0.1)
        }
    }
    
    private var buttonOpacity: Double {
        showCorrect && !isSelected && !isCorrect ? 0.5 : 1.0
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(circleFill)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(circleStroke, lineWidth: 2)
                        )
                    
                    if isSelected && isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(DesignColors.accent)
                    } else if isSelected && !isCorrect {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                    } else {
                        Text(optionLetter)
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                }
                
                Text(option)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(strokeColor, lineWidth: 1)
                    )
            )
            .opacity(buttonOpacity)
        }
        .disabled(showCorrect)
    }
}

struct QuestionReviewRow: View {
    let question: QuizQuestion
    let selectedAnswer: Int?
    let correctAnswer: Int
    
    private var isCorrect: Bool {
        selectedAnswer == correctAnswer
    }
    
    private var backgroundFill: Color {
        isCorrect ? DesignColors.accent.opacity(0.1) : Color.red.opacity(0.1)
    }
    
    private var strokeColor: Color {
        isCorrect ? DesignColors.accent.opacity(0.3) : Color.red.opacity(0.3)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question.question)
                .font(DesignTypography.bodyFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            VStack(spacing: 4) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    let isSelected = selectedAnswer == index
                    let isCorrectOption = index == correctAnswer
                    
                    HStack(spacing: 8) {
                        Text("\(String(Character(UnicodeScalar(65 + index)!))).")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .frame(width: 20)
                        
                        Text(option)
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(
                                isCorrectOption
                                    ? DesignColors.accent
                                    : isSelected && !isCorrectOption
                                    ? Color.red.opacity(0.8)
                                    : DesignColors.mutedForeground
                            )
                        
                        if isCorrectOption {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12))
                                .foregroundColor(DesignColors.accent)
                        }
                        
                        Spacer()
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                isCorrectOption
                                    ? DesignColors.accent.opacity(0.2)
                                    : isSelected && !isCorrectOption
                                    ? Color.red.opacity(0.1)
                                    : Color.white.opacity(0.05)
                            )
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundFill)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(strokeColor, lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationStack {
        QuizPage()
    }
}

