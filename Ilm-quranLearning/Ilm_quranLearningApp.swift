//
//  Ilm_quranLearningApp.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 16/04/2025.
//
import SwiftUI
import FirebaseCore

@main
struct Ilm_quranLearningApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RegisterView() // Entry point is now RegisterView
            }
        }
    }
}
