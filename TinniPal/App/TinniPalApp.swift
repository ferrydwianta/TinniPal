//
//  TinniPalApp.swift
//  TinniPal
//
//  Created by Ferry Dwianta P on 29/03/24.
//

import SwiftUI

@main
struct TinniPalApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
            } else {
                OnboardingView()
            }
        }
    }
}
