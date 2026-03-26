//
//  OnboardingView.swift
//  TinniPal
//
//  Created by Ferry Dwianta P on 26/03/26.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Persistence
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    // MARK: - Animation State
    @State private var isIconVisible = false
    @State private var isWelcomeVisible = false
    @State private var isAppNameVisible = false
    @State private var isDescriptionVisible = false
    @State private var isArrowVisible = false
    @State private var arrowBounce = false
    
    // MARK: - Page Transition
    @State private var isShowingHighlights = false
    @State private var dismissOpacity: Double = 1
    
    // MARK: - Highlights Animation State
    @State private var isCheckmarkVisible = false
    @State private var checkmarkBounce = false
    @State private var isHighlightsTitleVisible = false
    @State private var highlightRowsVisible: [Bool] = [false, false, false]
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            
            ZStack {
                // MARK: - Page 1: Welcome
                welcomePage(geometry: geometry)
                    .offset(y: isShowingHighlights ? -screenHeight : 0)
                
                // MARK: - Page 2: Highlights
                highlightsPage(geometry: geometry)
                    .offset(y: isShowingHighlights ? 0 : screenHeight)
            }
            .opacity(dismissOpacity)
        }
        .ignoresSafeArea()
        .onAppear {
            startWelcomeAnimations()
        }
    }
    
    // MARK: - Welcome Page
    @ViewBuilder
    private func welcomePage(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: geometry.size.height * 0.28)
            
            // App Icon
            Image("AppIconDisplay")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .scaleEffect(isIconVisible ? 1 : 0.5)
                .opacity(isIconVisible ? 1 : 0)
                .padding(.bottom, 24)
            
            // Title
            VStack(alignment: .leading, spacing: 0) {
                Text("Welcome to")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundStyle(.primary)
                    .offset(y: isWelcomeVisible ? 0 : 20)
                    .opacity(isWelcomeVisible ? 1 : 0)
                
                Text("TinniPal")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color("AccentColor"))
                    .offset(y: isAppNameVisible ? 0 : 20)
                    .opacity(isAppNameVisible ? 1 : 0)
            }
            .padding(.bottom, 16)
            
            // Description
            Text("Soothing sounds to help mask tinnitus, mixed just for you.")
                .font(.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .offset(y: isDescriptionVisible ? 0 : 12)
                .opacity(isDescriptionVisible ? 1 : 0)
            
            Spacer()
            
            // Arrow Button
            HStack {
                Spacer()
                Button {
                    transitionToHighlights()
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color("AccentColor"))
                        .frame(width: 50, height: 50)
                        .background(Color("AccentColor").opacity(0.25))
                        .clipShape(Circle())
                }
                .offset(y: arrowBounce ? -6 : 6)
                .opacity(isArrowVisible ? 1 : 0)
                Spacer()
            }
            .padding(.bottom, geometry.safeAreaInsets.bottom + 40)
        }
        .padding(.horizontal, 40)
        .frame(width: geometry.size.width, height: geometry.size.height)
    }
    
    // MARK: - Highlights Page
    @ViewBuilder
    private func highlightsPage(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: geometry.size.height * 0.28)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Discover")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundStyle(.primary)
                    .offset(y: isHighlightsTitleVisible ? 0 : 20)
                    .opacity(isHighlightsTitleVisible ? 1 : 0)
                
                Text("TinniPal")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color("AccentColor"))
                    .offset(y: isHighlightsTitleVisible ? 0 : 20)
                    .opacity(isHighlightsTitleVisible ? 1 : 0)
            }
            .padding(.bottom, 16)

            // Feature rows
            VStack(alignment: .leading, spacing: 16) {
                HighlightRow(
                    icon: "waveform.circle.fill",
                    title: "Mix Your Sounds",
                    description: "Combine ambient sounds to build a personalized relief soundscape that works for you."
                )
                .offset(y: highlightRowsVisible[0] ? 0 : 16)
                .opacity(highlightRowsVisible[0] ? 1 : 0)
                
                HighlightRow(
                    icon: "moon.circle.fill",
                    title: "Sleep Timer",
                    description: "Set a timer and drift off peacefully — sounds fade out gently before stopping."
                )
                .offset(y: highlightRowsVisible[1] ? 0 : 16)
                .opacity(highlightRowsVisible[1] ? 1 : 0)
                
                HighlightRow(
                    icon: "slider.horizontal.2.gobackward",
                    title: "Stereo Balance",
                    description: "Fine-tune left and right audio balance for personalized comfort in each ear."
                )
                .offset(y: highlightRowsVisible[2] ? 0 : 16)
                .opacity(highlightRowsVisible[2] ? 1 : 0)
            }
            
            Spacer()
            
            // Checkmark Button
            HStack {
                Spacer()
                Button {
                    dismissOnboarding()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background(Color("AccentColor"))
                        .clipShape(Circle())
                }
                .scaleEffect(isCheckmarkVisible ? 1 : 0.5)
                .opacity(isCheckmarkVisible ? 1 : 0)
                .offset(y: checkmarkBounce ? -6 : 6)
                Spacer()
            }
            .padding(.bottom, geometry.safeAreaInsets.bottom + 40)
        }
        .padding(.horizontal, 24)
        .frame(width: geometry.size.width, height: geometry.size.height)
    }
    
    // MARK: - Animations
    private func startWelcomeAnimations() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            isIconVisible = true
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
            isWelcomeVisible = true
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
            isAppNameVisible = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.7)) {
            isDescriptionVisible = true
        }
        withAnimation(.easeOut(duration: 0.3).delay(1.0)) {
            isArrowVisible = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                arrowBounce = true
            }
        }
    }
    
    private func startHighlightsAnimations() {
        withAnimation(.easeOut(duration: 0.4).delay(0.15)) {
            isHighlightsTitleVisible = true
        }
        for index in 0..<3 {
            withAnimation(.easeOut(duration: 0.4).delay(0.3 + Double(index) * 0.12)) {
                highlightRowsVisible[index] = true
            }
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.7)) {
            isCheckmarkVisible = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                checkmarkBounce = true
            }
        }
    }
    
    // MARK: - Transitions
    private func transitionToHighlights() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
            isShowingHighlights = true
        }
        startHighlightsAnimations()
    }
    
    private func dismissOnboarding() {
        withAnimation(.easeInOut(duration: 0.4)) {
            dismissOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            hasSeenOnboarding = true
        }
    }
}

// MARK: - Highlight Row
struct HighlightRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundStyle(Color("AccentColor"))
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
