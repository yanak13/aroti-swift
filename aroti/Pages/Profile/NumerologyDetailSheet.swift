//
//  NumerologyDetailSheet.swift
//  Aroti
//
//  Numerology detail modal matching Astrology style
//

import SwiftUI

struct NumerologyDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let blueprint: NumerologyBlueprint?
    
    init(blueprint: NumerologyBlueprint? = nil) {
        self.blueprint = blueprint
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: DesignSpacing.md) {
                        if let blueprint = blueprint {
                            // Header Section
                            VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                                Text("Life Path \(blueprint.lifePath.number) — \(blueprint.lifePath.name)")
                                    .font(DesignTypography.title2Font())
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(blueprint.lifePath.description)
                                    .font(DesignTypography.subheadFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            
                            // What Your Life Path Represents
                            VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                Text("What Your Life Path Represents")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(getLifePathDescription())
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
                                    
                                    Text(blueprint.lifePath.meaning)
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
                                
                                Text("Your primary qualities expressed through this number")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                    .multilineTextAlignment(.center)
                                
                                // Chips layout - natural wrapping using WrappingChipsView (same as Astrology)
                                WrappingChipsView(traits: blueprint.lifePath.traits, spacing: DesignSpacing.xs)
                            }
                            
                            // How This Energy Manifests
                            BaseCard {
                                VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                    Text("How This Energy Manifests")
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(getManifestationText(for: blueprint.lifePath.number))
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
                                        ForEach(getStrengths(for: blueprint.lifePath.number), id: \.self) { strength in
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
                                        ForEach(getChallenges(for: blueprint.lifePath.number), id: \.self) { challenge in
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
                                    
                                    Text(getPracticalInsights(for: blueprint.lifePath.number))
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .lineSpacing(4)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // About Life Path Number
                            BaseCard {
                                VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                                    Text("About Life Path Numbers")
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(getLifePathInfo())
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .lineSpacing(4)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text("No numerology data available")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    .padding(.vertical, DesignSpacing.sm)
                    .frame(maxWidth: .infinity)
                }
                .clipped()
            }
            .navigationTitle("Numerology")
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
    
    private func getLifePathDescription() -> String {
        return "Your Life Path number is the most significant number in your numerology chart. It represents your core purpose, the lessons you're here to learn, and the path you're meant to walk. This number reveals your natural talents, challenges, and the overall direction of your life journey."
    }
    
    private func getManifestationText(for number: Int) -> String {
        switch number {
        case 1:
            return "Your Life Path 1 manifests as natural leadership and independence. You're a pioneer who takes initiative, creates new paths, and inspires others with your courage and originality. Your energy is direct and forward-moving, often breaking new ground in whatever you pursue."
        case 2:
            return "Your Life Path 2 manifests through cooperation and harmony. You excel at bringing people together, creating partnerships, and finding balance. Your presence is calming and diplomatic, making you a natural mediator and collaborator."
        case 3:
            return "Your Life Path 3 manifests through creativity and self-expression. You communicate beautifully, inspire others with your joy and optimism, and have a natural gift for the arts. Your energy is vibrant, social, and full of enthusiasm."
        case 4:
            return "Your Life Path 4 manifests through structure and stability. You build things that last, value security and tradition, and work methodically toward your goals. Your presence is grounding and reliable, making you someone others can depend on."
        case 5:
            return "Your Life Path 5 manifests through freedom and adventure. You seek variety, embrace change, and thrive on new experiences. Your energy is dynamic and versatile, always ready for the next adventure or opportunity."
        case 6:
            return "Your Life Path 6 manifests through service and nurturing. You care deeply for others, create beautiful and harmonious environments, and find fulfillment in helping and supporting those around you. Your presence is warm and protective."
        case 7:
            return "Your Life Path 7 manifests through introspection and wisdom. You seek truth, value solitude for reflection, and have a natural inclination toward spiritual and philosophical pursuits. Your energy is thoughtful and mysterious."
        case 8:
            return "Your Life Path 8 manifests through achievement and material success. You have strong business acumen, build lasting structures, and understand the power of manifestation. Your presence is authoritative and goal-oriented."
        case 9:
            return "Your Life Path 9 manifests through compassion and universal love. You serve humanity, have a broad perspective, and work toward making the world a better place. Your energy is generous, idealistic, and deeply empathetic."
        default:
            return "Your Life Path number influences how you express your core purpose and navigate your life journey."
        }
    }
    
    private func getStrengths(for number: Int) -> [String] {
        switch number {
        case 1: return ["Leadership", "Independence", "Initiative"]
        case 2: return ["Cooperation", "Diplomacy", "Harmony"]
        case 3: return ["Creativity", "Communication", "Optimism"]
        case 4: return ["Stability", "Reliability", "Organization"]
        case 5: return ["Adaptability", "Freedom", "Adventure"]
        case 6: return ["Nurturing", "Service", "Responsibility"]
        case 7: return ["Wisdom", "Intuition", "Depth"]
        case 8: return ["Achievement", "Authority", "Manifestation"]
        case 9: return ["Compassion", "Idealism", "Universal Love"]
        default: return ["Unique strengths", "Personal power", "Natural gifts"]
        }
    }
    
    private func getChallenges(for number: Int) -> [String] {
        switch number {
        case 1: return ["Impatience", "Self-focus", "Dominance"]
        case 2: return ["Indecisiveness", "Over-sensitivity", "Dependency"]
        case 3: return ["Scattered energy", "Superficiality", "Exaggeration"]
        case 4: return ["Rigidity", "Stubbornness", "Resistance to change"]
        case 5: return ["Restlessness", "Impulsiveness", "Lack of commitment"]
        case 6: return ["Over-responsibility", "Worry", "Perfectionism"]
        case 7: return ["Isolation", "Skepticism", "Aloofness"]
        case 8: return ["Workaholism", "Material focus", "Power struggles"]
        case 9: return ["Self-sacrifice", "Idealism", "Difficulty letting go"]
        default: return ["Growth areas", "Learning opportunities", "Balance needed"]
        }
    }
    
    private func getPracticalInsights(for number: Int) -> String {
        switch number {
        case 1:
            return "To work with your Life Path 1, embrace your natural leadership abilities. Take initiative on projects that matter to you, trust your instincts, and don't be afraid to go first. Your independence is a gift—use it to create the life you envision."
        case 2:
            return "To honor your Life Path 2, focus on creating harmony in your relationships and environment. Your gift is bringing people together and finding common ground. Trust your intuition about others and value the power of partnership."
        case 3:
            return "To express your Life Path 3, find creative outlets that allow you to communicate and inspire. Share your joy and optimism with others. Your natural gift for expression can uplift and motivate those around you."
        case 4:
            return "To work with your Life Path 4, build solid foundations in all areas of your life. Create systems and structures that support your goals. Your methodical approach and reliability are your greatest assets."
        case 5:
            return "To embrace your Life Path 5, allow yourself freedom to explore and experience life fully. Change is your friend—embrace it rather than resist it. Your adaptability and versatility open doors to new opportunities."
        case 6:
            return "To honor your Life Path 6, focus on service and creating beauty in your environment. Your nurturing nature is a gift, but remember to care for yourself as well. Balance giving to others with receiving support."
        case 7:
            return "To work with your Life Path 7, make time for solitude and reflection. Trust your intuition and seek deeper understanding. Your natural wisdom comes from within—listen to your inner voice."
        case 8:
            return "To express your Life Path 8, focus on building lasting achievements and using your power wisely. Balance material success with spiritual growth. Your ability to manifest is strong—direct it toward positive goals."
        case 9:
            return "To honor your Life Path 9, serve humanity in ways that align with your values. Your compassion and idealism can create real change. Remember to also care for yourself while helping others."
        default:
            return "Understanding your Life Path number helps you work with your natural energies and develop greater self-awareness."
        }
    }
    
    private func getLifePathInfo() -> String {
        return "Life Path numbers are calculated from your birth date and represent your core purpose in this lifetime. Each number from 1 to 9 carries unique vibrations, lessons, and opportunities. Your Life Path reveals the path you're meant to walk, the talents you're here to develop, and the challenges that will help you grow. Understanding this number helps you align with your authentic self and live with greater purpose and fulfillment."
    }
}

