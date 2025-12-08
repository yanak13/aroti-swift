//
//  AstrologyDetailSheet.swift
//  Aroti
//
//  Astrology placement detail modal with comprehensive information
//

import SwiftUI

struct AstrologyDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let placement: PlanetaryPlacement
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        // Header Section
                        VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                            Text(placement.title)
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(placement.description)
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        
                        // What Your Planet Represents
                        VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                            Text("What Your \(placement.planet.capitalized) Represents")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(getPlanetDescription(for: placement.planet))
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .lineSpacing(4)
                        }
                        
                        // Core Meaning
                        BaseCard {
                            VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                Text("Core Meaning")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(placement.meaning)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Key Traits
                        VStack(alignment: .center, spacing: DesignSpacing.sm) {
                            Text("Key Traits")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("Your primary qualities expressed through this placement")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                            
                            // Chips layout - natural wrapping using CategoryChip (same as Discovery page)
                            let traits = getKeyTraits(for: placement.planet, sign: placement.sign)
                            
                            WrappingChipsView(traits: traits, spacing: DesignSpacing.xs)
                        }
                        
                        // How It Manifests
                        BaseCard {
                            VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                Text("How This Energy Manifests")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(getManifestationText(for: placement.planet, sign: placement.sign))
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Strengths & Challenges
                        HStack(alignment: .top, spacing: DesignSpacing.md) {
                            // Strengths
                            VStack(alignment: .center, spacing: DesignSpacing.sm) {
                                HStack(spacing: DesignSpacing.xs) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(DesignColors.accent)
                                    
                                    Text("Strengths")
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                }
                                
                                VStack(alignment: .center, spacing: DesignSpacing.xs) {
                                    ForEach(getStrengths(for: placement.planet, sign: placement.sign), id: \.self) { strength in
                                        Text("• \(strength)")
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Vertical divider
                            Rectangle()
                                .fill(DesignColors.border)
                                .frame(width: 1)
                            
                            // Challenges
                            VStack(alignment: .center, spacing: DesignSpacing.sm) {
                                HStack(spacing: DesignSpacing.xs) {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(DesignColors.accent.opacity(0.7))
                                    
                                    Text("Challenges")
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                }
                                
                                VStack(alignment: .center, spacing: DesignSpacing.xs) {
                                    ForEach(getChallenges(for: placement.planet, sign: placement.sign), id: \.self) { challenge in
                                        Text("• \(challenge)")
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        // Practical Insights
                        BaseCard {
                            VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                Text("Practical Insights")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(getPracticalInsights(for: placement.planet, sign: placement.sign))
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Sign Information
                        BaseCard {
                            VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                Text("About \(placement.sign)")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(getSignInfo(for: placement.sign))
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    .padding(.vertical, DesignSpacing.sm)
                    .frame(maxWidth: .infinity)
                }
                .clipped()
            }
            .navigationTitle("Astrology")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.accent)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func getPlanetDescription(for planet: String) -> String {
        switch planet.lowercased() {
        case "sun":
            return "Your Sun represents your core identity, ego, and life force. It's the essence of who you are at your deepest level—your authentic self, your willpower, and how you shine in the world. Your Sun sign shows your fundamental nature and the qualities you're here to develop and express."
        case "moon":
            return "Your Moon represents your emotional nature, inner world, and subconscious patterns. It governs how you process feelings, what makes you feel secure, and your instinctual reactions. Your Moon sign reveals your emotional needs and how you nurture yourself and others."
        case "rising", "ascendant":
            return "Your Rising sign (Ascendant) represents your outer personality, first impressions, and how others perceive you. It's the mask you wear and the energy you project to the world. Your Rising sign influences your appearance, demeanor, and the way you approach new situations."
        default:
            return "This planetary placement influences specific areas of your life and personality."
        }
    }
    
    private func getKeyTraits(for planet: String, sign: String) -> [String] {
        let baseTraits: [String: [String]] = [
            "sun": ["Core Identity", "Life Purpose", "Ego Expression", "Vitality", "Creative Drive"],
            "moon": ["Emotional Nature", "Instincts", "Nurturing Style", "Security Needs", "Subconscious Patterns"],
            "rising": ["Outer Personality", "First Impressions", "Physical Appearance", "Approach to Life", "Social Mask"]
        ]
        
        let signTraits: [String: [String]] = [
            "aries": ["Bold", "Pioneering", "Impulsive", "Energetic", "Independent"],
            "taurus": ["Stable", "Sensual", "Determined", "Patient", "Grounded"],
            "gemini": ["Curious", "Communicative", "Versatile", "Witty", "Adaptable"],
            "cancer": ["Nurturing", "Intuitive", "Emotional", "Protective", "Home-Loving"],
            "leo": ["Confident", "Creative", "Generous", "Dramatic", "Warm-Hearted"],
            "virgo": ["Analytical", "Practical", "Detail-Oriented", "Service-Oriented", "Perfectionist"],
            "libra": ["Diplomatic", "Harmonious", "Aesthetic", "Partnership-Focused", "Balanced"],
            "scorpio": ["Intense", "Transformative", "Passionate", "Mysterious", "Deep"],
            "sagittarius": ["Optimistic", "Adventurous", "Philosophical", "Freedom-Loving", "Expansive"],
            "capricorn": ["Ambitious", "Disciplined", "Responsible", "Traditional", "Achievement-Oriented"],
            "aquarius": ["Independent", "Innovative", "Humanitarian", "Unconventional", "Intellectual"],
            "pisces": ["Intuitive", "Compassionate", "Imaginative", "Empathetic", "Spiritual"]
        ]
        
        let planetKey = planet.lowercased()
        let signKey = sign.lowercased()
        
        var traits = baseTraits[planetKey] ?? []
        if let signSpecific = signTraits[signKey] {
            traits.append(contentsOf: signSpecific.prefix(3))
        }
        
        return Array(traits.prefix(8))
    }
    
    private func getManifestationText(for planet: String, sign: String) -> String {
        let planetLower = planet.lowercased()
        let signLower = sign.lowercased()
        
        if planetLower == "sun" {
            switch signLower {
            case "aries": return "Your Sun in Aries manifests as a natural leader who takes initiative. You're the first to start projects, speak up in meetings, and take action. Your energy is direct and forward-moving, often inspiring others with your courage and enthusiasm."
            case "taurus": return "Your Sun in Taurus manifests as steady, reliable energy. You build things that last, value comfort and beauty, and move at your own deliberate pace. Your presence is calming and grounding to others."
            case "gemini": return "Your Sun in Gemini manifests through communication and curiosity. You're always learning, sharing ideas, and connecting people. Your mind is quick and adaptable, making you excellent at multitasking and gathering information."
            case "cancer": return "Your Sun in Cancer manifests through emotional intelligence and nurturing. You create safe spaces for others, remember important details, and have a strong connection to home and family."
            case "leo": return "Your Sun in Leo manifests as radiant confidence and creativity. You naturally draw attention, express yourself dramatically, and inspire others with your warmth and generosity."
            case "virgo": return "Your Sun in Virgo manifests through practical service and attention to detail. You improve systems, help others solve problems, and find satisfaction in doing things well and efficiently."
            case "libra": return "Your Sun in Libra manifests through harmony and partnership. You seek balance in all things, appreciate beauty, and excel at bringing people together and finding common ground."
            case "scorpio": return "Your Sun in Scorpio manifests as intense depth and transformation. You go beneath the surface, uncover hidden truths, and have the power to regenerate and reinvent yourself."
            case "sagittarius": return "Your Sun in Sagittarius manifests through exploration and philosophy. You seek truth, adventure, and meaning, inspiring others with your optimism and broad perspective."
            case "capricorn": return "Your Sun in Capricorn manifests through ambition and structure. You build lasting achievements, respect tradition, and demonstrate discipline and responsibility."
            case "aquarius": return "Your Sun in Aquarius manifests as innovation and independence. You think outside the box, value freedom, and work toward progressive change for the collective."
            case "pisces": return "Your Sun in Pisces manifests through intuition and compassion. You feel deeply, connect to the spiritual realm, and express yourself through creativity and empathy."
            default: return "Your Sun sign influences how you express your core identity and life purpose."
            }
        } else if planetLower == "moon" {
            return "Your Moon in \(sign) influences how you process emotions, what makes you feel secure, and your instinctual responses. This placement reveals your emotional needs and how you nurture yourself and others."
        } else if planetLower == "rising" || planetLower == "ascendant" {
            return "Your Rising in \(sign) shapes your outer personality and first impressions. This is the energy you project to the world and how others initially perceive you."
        }
        
        return "This placement influences specific areas of your life and personality."
    }
    
    private func getStrengths(for planet: String, sign: String) -> [String] {
        let signLower = sign.lowercased()
        
        let strengths: [String: [String]] = [
            "aries": ["Courage", "Initiative", "Enthusiasm"],
            "taurus": ["Reliability", "Patience", "Stability"],
            "gemini": ["Communication", "Adaptability", "Curiosity"],
            "cancer": ["Nurturing", "Intuition", "Loyalty"],
            "leo": ["Confidence", "Creativity", "Generosity"],
            "virgo": ["Attention to detail", "Practicality", "Service"],
            "libra": ["Diplomacy", "Harmony", "Aesthetics"],
            "scorpio": ["Depth", "Transformation", "Intensity"],
            "sagittarius": ["Optimism", "Adventure", "Philosophy"],
            "capricorn": ["Ambition", "Discipline", "Responsibility"],
            "aquarius": ["Innovation", "Independence", "Humanitarianism"],
            "pisces": ["Intuition", "Compassion", "Creativity"]
        ]
        
        return strengths[signLower] ?? ["Unique strengths", "Personal power", "Natural gifts"]
    }
    
    private func getChallenges(for planet: String, sign: String) -> [String] {
        let signLower = sign.lowercased()
        
        let challenges: [String: [String]] = [
            "aries": ["Impatience", "Impulsiveness", "Self-focus"],
            "taurus": ["Stubbornness", "Resistance to change", "Possessiveness"],
            "gemini": ["Restlessness", "Scattered energy", "Superficiality"],
            "cancer": ["Moodiness", "Over-sensitivity", "Clinging"],
            "leo": ["Ego", "Drama", "Need for attention"],
            "virgo": ["Perfectionism", "Criticism", "Worry"],
            "libra": ["Indecisiveness", "Avoiding conflict", "People-pleasing"],
            "scorpio": ["Intensity", "Jealousy", "Secrecy"],
            "sagittarius": ["Restlessness", "Tactlessness", "Over-optimism"],
            "capricorn": ["Rigidity", "Workaholism", "Emotional distance"],
            "aquarius": ["Detachment", "Rebellion", "Eccentricity"],
            "pisces": ["Escapism", "Boundaries", "Victim mentality"]
        ]
        
        return challenges[signLower] ?? ["Growth areas", "Learning opportunities", "Balance needed"]
    }
    
    private func getPracticalInsights(for planet: String, sign: String) -> String {
        let planetLower = planet.lowercased()
        
        if planetLower == "sun" {
            return "To work with your Sun in \(sign), focus on expressing your authentic self. This is where you find your greatest joy and sense of purpose. When you align with this energy, you feel most alive and confident."
        } else if planetLower == "moon" {
            return "To honor your Moon in \(sign), pay attention to your emotional needs. Create environments and routines that make you feel secure and nurtured. This is how you recharge and maintain emotional balance."
        } else if planetLower == "rising" || planetLower == "ascendant" {
            return "Your Rising in \(sign) is your natural approach to new situations. Use this energy to make positive first impressions and navigate social situations. This is the mask you wear, but it's also a genuine part of who you are."
        }
        
        return "Understanding this placement helps you work with your natural energies and develop greater self-awareness."
    }
    
    private func getSignInfo(for sign: String) -> String {
        let signLower = sign.lowercased()
        
        let info: [String: String] = [
            "aries": "Aries is the first sign of the zodiac, ruled by Mars. It's a fire sign known for courage, initiative, and pioneering spirit. Aries energy is direct, energetic, and always ready to begin new adventures.",
            "taurus": "Taurus is an earth sign ruled by Venus. It's known for stability, sensuality, and determination. Taurus energy is grounded, patient, and values comfort, beauty, and lasting things.",
            "gemini": "Gemini is an air sign ruled by Mercury. It's known for curiosity, communication, and versatility. Gemini energy is quick, adaptable, and always seeking to learn and share information.",
            "cancer": "Cancer is a water sign ruled by the Moon. It's known for nurturing, intuition, and emotional depth. Cancer energy is protective, home-loving, and deeply connected to family and security.",
            "leo": "Leo is a fire sign ruled by the Sun. It's known for confidence, creativity, and generosity. Leo energy is warm, dramatic, and naturally draws attention through self-expression.",
            "virgo": "Virgo is an earth sign ruled by Mercury. It's known for analysis, service, and attention to detail. Virgo energy is practical, organized, and focused on improvement and efficiency.",
            "libra": "Libra is an air sign ruled by Venus. It's known for harmony, partnership, and aesthetics. Libra energy seeks balance, beauty, and connection, often acting as a mediator.",
            "scorpio": "Scorpio is a water sign ruled by Mars and Pluto. It's known for intensity, transformation, and depth. Scorpio energy goes beneath the surface, uncovering hidden truths and regenerating.",
            "sagittarius": "Sagittarius is a fire sign ruled by Jupiter. It's known for optimism, adventure, and philosophy. Sagittarius energy seeks truth, expansion, and meaning through exploration.",
            "capricorn": "Capricorn is an earth sign ruled by Saturn. It's known for ambition, discipline, and responsibility. Capricorn energy builds lasting structures, respects tradition, and achieves through hard work.",
            "aquarius": "Aquarius is an air sign ruled by Saturn and Uranus. It's known for innovation, independence, and humanitarianism. Aquarius energy thinks outside the box and works for progressive change.",
            "pisces": "Pisces is a water sign ruled by Jupiter and Neptune. It's known for intuition, compassion, and spirituality. Pisces energy is empathetic, creative, and deeply connected to the unseen realms."
        ]
        
        return info[signLower] ?? "This sign has unique qualities that influence your personality and life path."
    }
}

// MARK: - Wrapping Chips View
struct WrappingChipsView: View {
    let traits: [String]
    let spacing: CGFloat
    @State private var containerWidth: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            ForEach(createRows(), id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { trait in
                        CategoryChip(
                            label: trait,
                            isActive: true,
                            action: {}
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
            }
        )
        .onPreferenceChange(WidthPreferenceKey.self) { newWidth in
            if newWidth > 0 {
                containerWidth = newWidth
            }
        }
    }
    
    private func createRows() -> [[String]] {
        // Use screen width minus padding as initial estimate
        let estimatedWidth = containerWidth > 0 ? containerWidth : (UIScreen.main.bounds.width - (DesignSpacing.sm * 2))
        
        guard estimatedWidth > 0 else {
            // Fallback: show all in single row if width can't be determined
            return [traits]
        }
        
        var rows: [[String]] = []
        var currentRow: [String] = []
        var currentRowWidth: CGFloat = 0
        
        for trait in traits {
            let chipWidth = estimateChipWidth(trait)
            let neededWidth = currentRowWidth + chipWidth + (currentRow.isEmpty ? 0 : spacing)
            
            if neededWidth <= estimatedWidth {
                currentRow.append(trait)
                currentRowWidth = neededWidth
            } else {
                if !currentRow.isEmpty {
                    rows.append(currentRow)
                }
                currentRow = [trait]
                currentRowWidth = chipWidth
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows.isEmpty ? [traits] : rows
    }
    
    private func estimateChipWidth(_ text: String) -> CGFloat {
        // Approximate chip width: text + padding (12*2) + border
        // Using caption1 font size (13pt) same as CategoryChip
        let font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        let textWidth = text.size(withAttributes: [.font: font]).width
        return textWidth + 24 + 4 // padding + border
    }
}

// MARK: - Width Preference Key
struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Array Extension for Chunking
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

