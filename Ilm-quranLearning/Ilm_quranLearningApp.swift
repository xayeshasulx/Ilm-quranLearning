//
//  Ilm_quranLearningApp.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 16/04/2025.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct Ilm_quranLearningApp: App {
    @StateObject private var viewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if viewModel.isSignedIn {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
}


