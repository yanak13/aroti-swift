//
//  ChineseZodiacDetailSheet.swift
//  Aroti
//
//  Chinese Zodiac detail modal matching Astrology and Numerology style
//

import SwiftUI

struct ChineseZodiacDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let blueprint: ChineseZodiacBlueprint
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        // Header Section
                        VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                            Text("\(blueprint.fullSign) — \(blueprint.animal)")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(blueprint.description)
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        
                        // What Your Chinese Zodiac Represents
                        VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                            Text("What Your Chinese Zodiac Represents")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(getChineseZodiacDescription())
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
                                
                                Text(getCoreMeaning(for: blueprint.animal, element: blueprint.element))
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
                            
                            Text("Your primary qualities expressed through this sign")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                            
                            // Chips layout - natural wrapping using WrappingChipsView (same as Astrology)
                            WrappingChipsView(traits: blueprint.traits, spacing: DesignSpacing.xs)
                        }
                        
                        // How This Energy Manifests
                        BaseCard {
                            VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                Text("How This Energy Manifests")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(getManifestationText(for: blueprint.animal, element: blueprint.element))
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
                                    ForEach(getStrengths(for: blueprint.animal), id: \.self) { strength in
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
                                    ForEach(getChallenges(for: blueprint.animal), id: \.self) { challenge in
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
                                
                                Text(getPracticalInsights(for: blueprint.animal, element: blueprint.element))
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // About Chinese Zodiac
                        BaseCard {
                            VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                Text("About Chinese Zodiac")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(getChineseZodiacInfo())
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
            .navigationTitle("Chinese Zodiac")
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
    
    private func getChineseZodiacDescription() -> String {
        return "Your Chinese zodiac sign is determined by your birth year and represents your core personality traits, natural tendencies, and life path. The Chinese zodiac combines twelve animal signs with five elements (Metal, Water, Wood, Fire, Earth), creating a 60-year cycle. Your sign reveals your character, strengths, challenges, and how you interact with the world around you."
    }
    
    private func getCoreMeaning(for animal: String, element: String) -> String {
        let animalLower = animal.lowercased()
        let elementLower = element.lowercased()
        
        var meaning = ""
        
        // Animal meaning
        switch animalLower {
        case "rat":
            meaning = "As a \(animal), you are clever, resourceful, and adaptable. You excel in social situations and have natural charm. "
        case "ox":
            meaning = "As an \(animal), you are diligent, dependable, and strong. You value hard work and are known for your reliability. "
        case "tiger":
            meaning = "As a \(animal), you are brave, confident, and passionate. You're a natural leader with a strong sense of justice. "
        case "rabbit":
            meaning = "As a \(animal), you are gentle, elegant, and peaceful. You value harmony and have refined taste. "
        case "dragon":
            meaning = "As a \(animal), you are ambitious, energetic, and powerful. You're a natural leader with great vision. "
        case "snake":
            meaning = "As a \(animal), you are wise, intuitive, and mysterious. You have deep insight and value wisdom. "
        case "horse":
            meaning = "As a \(animal), you are energetic, independent, and free-spirited. You value freedom and have a strong will. "
        case "goat":
            meaning = "As a \(animal), you are creative, gentle, and artistic. You value beauty and have a calm, nurturing nature. "
        case "monkey":
            meaning = "As a \(animal), you are witty, intelligent, and playful. You're quick-thinking and have a great sense of humor. "
        case "rooster":
            meaning = "As a \(animal), you are confident, observant, and organized. You're punctual and value precision. "
        case "dog":
            meaning = "As a \(animal), you are loyal, honest, and protective. You value justice and have a strong sense of duty. "
        case "pig":
            meaning = "As a \(animal), you are generous, sincere, and compassionate. You value peace and have a warm heart. "
        default:
            meaning = "Your Chinese zodiac sign reflects your personality and characteristics. "
        }
        
        // Element meaning
        switch elementLower {
        case "metal":
            meaning += "The Metal element adds strength, determination, and structure to your nature. You value discipline and precision."
        case "water":
            meaning += "The Water element adds intuition, adaptability, and emotional depth to your nature. You flow with life's changes."
        case "wood":
            meaning += "The Wood element adds growth, creativity, and flexibility to your nature. You seek expansion and new possibilities."
        case "fire":
            meaning += "The Fire element adds passion, enthusiasm, and dynamism to your nature. You bring energy and inspiration to others."
        case "earth":
            meaning += "The Earth element adds stability, practicality, and grounding to your nature. You value security and tradition."
        default:
            meaning += "Your element influences how you express your zodiac sign's qualities."
        }
        
        return meaning
    }
    
    private func getManifestationText(for animal: String, element: String) -> String {
        let animalLower = animal.lowercased()
        let _ = element.lowercased()
        
        var manifestation = ""
        
        switch animalLower {
        case "rat":
            manifestation = "Your \(element) \(animal) energy manifests through quick thinking and social intelligence. You're always finding creative solutions and building connections. Your adaptability helps you thrive in changing circumstances."
        case "ox":
            manifestation = "Your \(element) \(animal) energy manifests through steady, methodical progress. You build lasting foundations and can be counted on. Your strength comes from persistence and reliability."
        case "tiger":
            manifestation = "Your \(element) \(animal) energy manifests through bold action and natural leadership. You inspire others with your courage and take initiative. Your passion drives you to pursue justice and adventure."
        case "rabbit":
            manifestation = "Your \(element) \(animal) energy manifests through grace and diplomacy. You create harmony in your environment and value beauty. Your gentle nature makes you a natural peacemaker."
        case "dragon":
            manifestation = "Your \(element) \(animal) energy manifests through powerful vision and charisma. You naturally draw attention and inspire others. Your ambition drives you to achieve great things."
        case "snake":
            manifestation = "Your \(element) \(animal) energy manifests through deep insight and intuition. You see beneath the surface and value wisdom. Your mysterious nature adds depth to your interactions."
        case "horse":
            manifestation = "Your \(element) \(animal) energy manifests through freedom and adventure. You seek new experiences and value independence. Your energetic nature keeps you moving forward."
        case "goat":
            manifestation = "Your \(element) \(animal) energy manifests through creativity and nurturing. You create beauty and care for others. Your artistic nature brings harmony to your surroundings."
        case "monkey":
            manifestation = "Your \(element) \(animal) energy manifests through intelligence and playfulness. You solve problems creatively and bring joy to others. Your quick thinking helps you adapt to any situation."
        case "rooster":
            manifestation = "Your \(element) \(animal) energy manifests through organization and precision. You value order and attention to detail. Your confidence helps you take charge when needed."
        case "dog":
            manifestation = "Your \(element) \(animal) energy manifests through loyalty and protection. You stand up for what's right and care deeply for others. Your sense of duty guides your actions."
        case "pig":
            manifestation = "Your \(element) \(animal) energy manifests through generosity and sincerity. You create warmth and peace in your environment. Your compassionate nature makes others feel valued."
        default:
            manifestation = "Your Chinese zodiac sign influences how you express yourself and interact with the world."
        }
        
        return manifestation
    }
    
    private func getStrengths(for animal: String) -> [String] {
        let animalLower = animal.lowercased()
        
        let strengths: [String: [String]] = [
            "rat": ["Cleverness", "Resourcefulness", "Adaptability"],
            "ox": ["Diligence", "Reliability", "Strength"],
            "tiger": ["Courage", "Leadership", "Passion"],
            "rabbit": ["Diplomacy", "Grace", "Harmony"],
            "dragon": ["Ambition", "Charisma", "Vision"],
            "snake": ["Wisdom", "Intuition", "Depth"],
            "horse": ["Independence", "Energy", "Adventure"],
            "goat": ["Creativity", "Nurturing", "Artistic"],
            "monkey": ["Intelligence", "Wit", "Adaptability"],
            "rooster": ["Organization", "Confidence", "Precision"],
            "dog": ["Loyalty", "Honesty", "Protection"],
            "pig": ["Generosity", "Compassion", "Sincerity"]
        ]
        
        return strengths[animalLower] ?? ["Unique strengths", "Personal power", "Natural gifts"]
    }
    
    private func getChallenges(for animal: String) -> [String] {
        let animalLower = animal.lowercased()
        
        let challenges: [String: [String]] = [
            "rat": ["Restlessness", "Opportunism", "Nervousness"],
            "ox": ["Stubbornness", "Rigidity", "Overwork"],
            "tiger": ["Impulsiveness", "Aggression", "Impatience"],
            "rabbit": ["Indecisiveness", "Over-caution", "Avoidance"],
            "dragon": ["Arrogance", "Impatience", "Dominance"],
            "snake": ["Jealousy", "Secretiveness", "Distrust"],
            "horse": ["Restlessness", "Impatience", "Independence"],
            "goat": ["Worry", "Indecisiveness", "Passivity"],
            "monkey": ["Restlessness", "Trickery", "Inconsistency"],
            "rooster": ["Critical nature", "Perfectionism", "Arrogance"],
            "dog": ["Worry", "Cynicism", "Over-protectiveness"],
            "pig": ["Naivety", "Gullibility", "Over-indulgence"]
        ]
        
        return challenges[animalLower] ?? ["Growth areas", "Learning opportunities", "Balance needed"]
    }
    
    private func getPracticalInsights(for animal: String, element: String) -> String {
        let animalLower = animal.lowercased()
        
        switch animalLower {
        case "rat":
            return "To work with your \(element) \(animal) energy, embrace your natural cleverness and social skills. Use your adaptability to navigate change, and trust your resourcefulness to find solutions. Your ability to connect with others is a great strength—use it to build meaningful relationships."
        case "ox":
            return "To honor your \(element) \(animal) energy, focus on steady progress and building lasting foundations. Your reliability is a gift—others count on you. Remember to balance hard work with rest, and don't be afraid to ask for help when needed."
        case "tiger":
            return "To express your \(element) \(animal) energy, embrace your natural leadership and courage. Take bold action on things that matter to you, and use your passion to inspire others. Channel your energy into positive pursuits and remember to be patient with others."
        case "rabbit":
            return "To work with your \(element) \(animal) energy, trust your diplomatic skills and create harmony in your environment. Your gentle nature is a strength—use it to bring people together. Don't avoid necessary conflicts, but approach them with grace."
        case "dragon":
            return "To honor your \(element) \(animal) energy, channel your ambition and charisma toward meaningful goals. Your vision inspires others—share it generously. Remember to listen to others' perspectives and balance confidence with humility."
        case "snake":
            return "To express your \(element) \(animal) energy, trust your intuition and seek deeper understanding. Your wisdom comes from observation and reflection. Share your insights with others while respecting their boundaries and privacy."
        case "horse":
            return "To work with your \(element) \(animal) energy, embrace your need for freedom while building stable foundations. Your energy and independence are gifts—use them to explore and grow. Remember that commitment doesn't mean losing your freedom."
        case "goat":
            return "To honor your \(element) \(animal) energy, express your creativity and nurture your artistic side. Your gentle nature creates beauty and harmony. Balance caring for others with self-care, and trust your creative instincts."
        case "monkey":
            return "To express your \(element) \(animal) energy, use your intelligence and wit to solve problems creatively. Your playfulness brings joy to others—share it freely. Channel your quick thinking into productive pursuits and maintain consistency."
        case "rooster":
            return "To work with your \(element) \(animal) energy, use your organizational skills and precision to create order. Your confidence helps you take charge—use it wisely. Balance your attention to detail with flexibility, and be gentle in your critiques."
        case "dog":
            return "To honor your \(element) \(animal) energy, trust your loyalty and sense of justice. Your protective nature is a gift—use it to support those you care about. Remember to also protect yourself and avoid excessive worry."
        case "pig":
            return "To express your \(element) \(animal) energy, embrace your generosity and create warmth in your environment. Your sincerity and compassion make others feel valued. Balance giving with receiving, and maintain healthy boundaries."
        default:
            return "Understanding your Chinese zodiac sign helps you work with your natural energies and develop greater self-awareness."
        }
    }
    
    private func getChineseZodiacInfo() -> String {
        return "The Chinese zodiac, also known as Shengxiao, is a 12-year cycle where each year is represented by an animal sign. Combined with five elements (Metal, Water, Wood, Fire, Earth), this creates a 60-year cycle. The Chinese zodiac is based on the lunar calendar and has been used for thousands of years to understand personality traits, compatibility, and life paths. Your zodiac sign reveals your character, natural tendencies, strengths, and areas for growth. Understanding your sign helps you align with your authentic nature and navigate life with greater awareness."
    }
}
