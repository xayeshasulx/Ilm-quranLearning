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
    let id: String
    let translation: String

    enum CodingKeys: String, CodingKey {
        case id
        case translation = "text"
    }

    init(id: String = UUID().uuidString, translation: String) {
        self.id = id
        self.translation = translation
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.translation = try container.decode(String.self, forKey: .translation)

        // ✅ Decode id if it exists — otherwise generate and LOG it
        if let existingId = try? container.decode(String.self, forKey: .id) {
            self.id = existingId
        } else {
            let generated = UUID().uuidString
            print("Missing ID for: \(self.translation), generated: \(generated)")
            self.id = generated
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: KeyTheme, rhs: KeyTheme) -> Bool {
        lhs.id == rhs.id
    }
}



