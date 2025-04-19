//
//  FavouritesCreatedView.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 18/04/2025.
//
import SwiftUI

struct FavouritesCreatedView: View {
    let theme: KeyTheme
    @EnvironmentObject var favourites: FavouritesStore
    @Environment(\.dismiss) var dismiss

    @State private var folderName: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Custom Top Bar
            ZStack(alignment: .center) {
                Color(hex: "722345").ignoresSafeArea(edges: .top)

                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    Text("Add to folder")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    Spacer()
                    Spacer().frame(width: 32)
                }
                .padding(.vertical, 8)
            }
            .frame(height: 56)

            VStack(spacing: 16) {
                Text("Create new folder")
                    .font(.headline)
                    .padding(.top)

                TextField("Enter folder name", text: $folderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Divider()

            
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(favourites.themeFolders, id: \.id) { folder in
                            Button(action: {
                                save(to: folder.name)
                            }) {
                                HStack(spacing: 12) { // appearance of folders
                                    Image(systemName: "folder.fill")
                                        .foregroundColor(Color(hex: "722345"))
                                    Text(folder.name)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                Button(action: {
                    save(to: folderName)
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "A46A79"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .contentShape(Rectangle())
                .padding()
            }
        }
    }

    private func save(to folder: String) {
        let trimmed = folder.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        favourites.toggleFavourite(theme, to: trimmed)
        dismiss()
    }
}

