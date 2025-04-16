//
//  ArabicWords.swift
//  Ilm
//
//  Created by Ayesha Suleman on 08/04/2025.
//
import Foundation
import SwiftUI

class ArabicWordsViewModel: ObservableObject {
    @Published var words: [ArabicWord] = []

    init() {
        loadWords()
    }

    private func loadWords() {
        guard let url = Bundle.main.url(forResource: "arabic_words", withExtension: "json") else {
            print("arabic_words.json not found.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([ArabicWord].self, from: data)
            DispatchQueue.main.async {
                self.words = decoded
                print("Loaded \(decoded.count) Arabic words")
            }
        } catch {
            print("Error decoding Arabic Words JSON: \(error.localizedDescription)")
        }
    }
}

