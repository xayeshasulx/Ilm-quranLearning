//
//  FavoritesStore.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 17/04/2025.
//

// Favourites/FavoritesStore.swift

import SwiftUI

class FavoritesStore: ObservableObject {
    @Published var themeFolders: [FavoriteThemeFolder] = []

    // MARK: - Toggle KeyTheme in Folder
    func toggleFavorite(_ theme: KeyTheme, to folderName: String) {
        let trimmed = folderName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let index = themeFolders.firstIndex(where: { $0.name == trimmed }) {
            if themeFolders[index].themes.contains(theme) {
                themeFolders[index].themes.removeAll { $0 == theme }
            } else {
                themeFolders[index].themes.append(theme)
            }
        } else {
            let newFolder = FavoriteThemeFolder(name: trimmed, themes: [theme])
            themeFolders.append(newFolder)
        }
    }

    // MARK: - Check if Theme is Favorited
    func isFavorited(_ theme: KeyTheme) -> Bool {
        themeFolders.contains { $0.themes.contains(theme) }
    }

    // MARK: - Get All Themes in Folder
    func themes(in folder: FavoriteThemeFolder) -> [KeyTheme] {
        folder.themes
    }

    func deleteFolder(_ folder: FavoriteThemeFolder) {
        themeFolders.removeAll { $0 == folder }
    }
}

// MARK: - Folder Model for Themes
struct FavoriteThemeFolder: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var themes: [KeyTheme]
}
