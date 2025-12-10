import SwiftUI

struct DesignComponentsView: View {
    var body: some View {
        ZStack {
            CelestialBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    header
                    typographySection
                    colorsSection
                    buttonsSection
                    inputsSection
                    cardsSection
                    navigationSection
                    badgesSection
                    iconsSection
                    layoutSection
                    modalsSection
                    avatarsSection
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.bottom, DesignSpacing.xl)
                .padding(.top, 80)
            }
        }
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        BaseHeader(
            title: "Design Components",
            subtitle: "All reusable components used in the app",
            leftAction: BaseHeader.HeaderAction(
                icon: Image(systemName: "chevron.left"),
                label: "Go back",
                action: {}
            )
        )
    }
    
    private var typographySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "A. Typography",
                subtitle: "Text styles and sizes used throughout the app"
            )
            TypographySizesView()
            TypographyWeightsView()
            TypographyColorsView()
        }
    }
    
    private var colorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "B. Colors",
                subtitle: "Unified SwiftUI tokens sourced from DesignSystem.swift"
            )
            ColorVariablesView()
            SurfaceColorsView()
            StatusColorsView()
            GradientColorsView()
        }
    }
    
    private var buttonsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "C. Buttons",
                subtitle: "Unified ArotiButton variants, icons, and states"
            )
            ButtonVariantsMatrixView()
            IconicButtonsView()
            DisabledButtonsView()
            GradientButtonShowcase()
            CTAButtonShowcase()
            SSOButtonShowcase()
            AccentCardButtonView()
            GlassCardButtonView()
            PremiumUnlockButtonView()
            FloatingActionButtonView()
            LockIconButtonsView()
            DatePillButtonsView()
            TimeSlotButtonsView()
            EditProfileButtonView()
            ReflectionActionButtonsView()
            ShareImageButtonsView()
        }
    }
    
    private var inputsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "D. Inputs & Forms",
                subtitle: "Input and form controls"
            )
            TextInputsShowcase()
            SearchInputShowcase()
            TextareaShowcase()
            SliderShowcase()
            SortDropdownShowcase()
            FilterTabsShowcase()
            CalendarShowcase()
        }
    }
    
    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "E. Cards",
                subtitle: "Card components used throughout the app"
            )
            BaseCardVariantsView()
            TodaysRitualCardView()
            ReflectionCardView()
            RevealedInsightCardsView()
            SpecialistCardShowcase()
            UpcomingSessionCardView()
            RecentlyViewedCardView()
            DailyPracticeCardView()
            DailyQuizCardView()
            YourJourneyCardView()
            SpreadCardCarousel()
            TarotSpreadCardCarousel()
            SoftCardShowcase()
            DailyAffirmationCardView()
            HoroscopeCardView()
            NumerologyCardView()
            CourseCardView()
            ReportCardView()
            MembershipCardView()
            SavedContentCardView()
            BookingSummaryCardView()
            SettingsListCardView()
            AstrologyBlueprintCardView()
            NumerologyBlueprintCardView()
        }
    }
    
    private var navigationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "F. Tabs / Navigation",
                subtitle: "Tab and navigation components"
            )
            TabPillsShowcase()
            HeaderTopBarView()
            BottomNavigationInfoView()
        }
    }
    
    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "G. Badges / Tags / Points",
                subtitle: "Status labels, category tags, and badges"
            )
            StatusChipShowcase()
            CategoryChipShowcase()
            CardTagsShowcase()
            TypeBadgeShowcase()
            DifficultyBadgeShowcase()
            CardCountBadgeShowcase()
            RatingBadgeShowcase()
            PriceBadgeShowcase()
            AvailabilityBadgeShowcase()
        }
    }
    
    private var iconsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "H. Icons",
                subtitle: "All icons used in the app from SF Symbols"
            )
            IconLibraryGrid()
        }
    }
    
    private var layoutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "Layout Components",
                subtitle: "Core layout and structure components"
            )
            BaseSectionHeaderShowcase()
            SectionHeaderShowcase()
            GridLayoutDemo()
            HorizontalCardCarouselView()
            TagCarouselView()
            ListLayoutDemo()
        }
    }
    
    private var modalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "I. Modals / Overlays",
                subtitle: "Modal and dialog components"
            )
            UnifiedModalDemo()
            TarotModalDemo()
        }
    }
    
    private var avatarsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BaseSectionHeader(
                title: "Avatars",
                subtitle: "Profile images and avatars"
            )
            LargeSpecialistAvatarView()
            ListAvatarView()
            ProfileAvatarView()
        }
    }
}

#Preview {
    NavigationStack {
        DesignComponentsView()
    }
}
