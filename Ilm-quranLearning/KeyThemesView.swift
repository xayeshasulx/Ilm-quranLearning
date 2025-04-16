//
//  KeyThemesView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 08/04/2025.
//

import Foundation

struct KeyThemePost: Codable {
    let surah: String
    let posts: [KeyTheme]
}

struct KeyTheme: Codable, Identifiable, Equatable, Hashable {
    var id = UUID()
    let translation: String

    private enum CodingKeys: String, CodingKey {
        case translation = "text"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.translation = try container.decode(String.self, forKey: .translation)
    }

    init(translation: String) {
        self.translation = translation
    }

    static func == (lhs: KeyTheme, rhs: KeyTheme) -> Bool {
        lhs.translation == rhs.translation
    }
}
