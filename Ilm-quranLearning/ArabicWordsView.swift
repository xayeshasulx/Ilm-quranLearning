//
//  ArabicWordsView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 15/04/2025.
//
import SwiftUI
import Foundation

struct ArabicWord: Codable, Identifiable, Hashable {
    var id = UUID()
    let arabic: String
    let translation: String
    let transliteration: String
    let occurrences: String

    private enum CodingKeys: String, CodingKey {
        case arabic
        case translation
        case transliteration
        case occurrences
    }

    static func == (lhs: ArabicWord, rhs: ArabicWord) -> Bool {
        lhs.arabic == rhs.arabic &&
        lhs.translation == rhs.translation &&
        lhs.transliteration == rhs.transliteration &&
        lhs.occurrences == rhs.occurrences
    }
}

