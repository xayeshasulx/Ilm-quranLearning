//
//  FavoritesStore.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 17/04/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class FavouritesStore: ObservableObject {
    @Published var themeFolders: [FavouriteThemeFolder] = []

    private let db = Firestore.firestore()

    init() {
        loadFoldersFromFirestore()
    }

    func toggleFavourite(_ theme: KeyTheme, to folderName: String) {
        let trimmed = folderName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let index = themeFolders.firstIndex(where: { $0.name == trimmed }) {
            if let themeIndex = themeFolders[index].themes.firstIndex(of: theme) {
                themeFolders[index].themes.remove(at: themeIndex)
            } else {
                themeFolders[index].themes.append(theme)
            }
            saveFolderToFirestore(folder: themeFolders[index])
        } else {
            let newFolder = FavouriteThemeFolder(name: trimmed, themes: [theme])
            themeFolders.append(newFolder)
            saveFolderToFirestore(folder: newFolder)
        }
    }

    func isFavourited(_ theme: KeyTheme) -> Bool {
        themeFolders.contains { folder in
            folder.themes.contains { $0.id == theme.id }
        }
    }

    func removeFromFavourites(_ theme: KeyTheme) {
        for index in themeFolders.indices {
            if themeFolders[index].themes.contains(where: { $0.id == theme.id }) {
                themeFolders[index].themes.removeAll { $0.id == theme.id }

                if themeFolders[index].themes.isEmpty {
                    let folder = themeFolders[index]
                    deleteFolder(folder)
                } else {
                    saveFolderToFirestore(folder: themeFolders[index])
                }

                break
            }
        }
    }

    private func saveFolderToFirestore(folder: FavouriteThemeFolder) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let themeMaps = folder.themes.map { theme in
            [
                "id": theme.id,  // 🔐 Ensure ID is stored
                "translation": theme.translation,
                "addedAt": Timestamp(date: Date())
            ]
        }

        let data: [String: Any] = [
            "uid": userId,
            "name": folder.name,
            "createdAt": Timestamp(date: Date()),
            "themes": themeMaps
        ]

        db.collection("favourites")
            .whereField("uid", isEqualTo: userId)
            .whereField("name", isEqualTo: folder.name)
            .getDocuments { snapshot, _ in
                if let doc = snapshot?.documents.first {
                    self.db.collection("favourites").document(doc.documentID).setData(data)
                } else {
                    self.db.collection("favourites").addDocument(data: data)
                }
            }
    }

    func deleteFolder(_ folder: FavouriteThemeFolder) {
        themeFolders.removeAll { $0 == folder }

        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("favourites")
            .whereField("uid", isEqualTo: userId)
            .whereField("name", isEqualTo: folder.name)
            .getDocuments { snapshot, _ in
                snapshot?.documents.forEach { doc in
                    self.db.collection("favourites").document(doc.documentID).delete()
                }
            }
    }

    func loadFoldersFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("favourites")
            .whereField("uid", isEqualTo: userId)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }

                var folders: [FavouriteThemeFolder] = []

                for doc in documents {
                    let data = doc.data()
                    let name = data["name"] as? String ?? "Unnamed Folder"
                    let themeArray = data["themes"] as? [[String: Any]] ?? []

                    let themes: [KeyTheme] = themeArray.compactMap { dict in
                        guard let id = dict["id"] as? String,
                              let translation = dict["translation"] as? String else { return nil }
                        return KeyTheme(id: id, translation: translation)
                    }

                    let folder = FavouriteThemeFolder(name: name, themes: themes)
                    folders.append(folder)
                }

                DispatchQueue.main.async {
                    self.themeFolders = folders
                }
            }
    }

    func renameFolder(at index: Int, to newName: String) {
        var updatedFolder = themeFolders[index]
        updatedFolder.name = newName
        themeFolders[index] = updatedFolder
        saveFolderToFirestore(folder: updatedFolder)
    }
}

struct FavouriteThemeFolder: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var themes: [KeyTheme]
}
