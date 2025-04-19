//
//  FavouritesListView.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 18/04/2025.
//
import SwiftUI

struct FavouritesListView: View {
    @EnvironmentObject var favorites: FavouritesStore

    @State private var selectedFolder: FavouriteThemeFolder?
    @State private var showFolderOptions = false
    @State private var showDeleteConfirmation = false
    @State private var showRenameDialog = false
    @State private var renameText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    Color(hex: "722345").ignoresSafeArea(edges: .top)
                    HStack {
                        Spacer()
                        Text("Favourites")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "D4B4AC"))
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .frame(height: 56)

                if favorites.themeFolders.isEmpty {
                    Spacer()
                    Text("No folders created yet.")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(favorites.themeFolders) { folder in
                                HStack(spacing: 12) {
                                    NavigationLink(destination: FavouritesView(folder: folder)) {
                                        HStack {
                                            Image(systemName: "folder.fill")
                                                .foregroundColor(.accentColor)
                                                .font(.title2)
                                            Text(folder.name)
                                                .font(.body)
                                            Spacer()
                                        }
                                    }

                                    Button {
                                        selectedFolder = folder
                                        showFolderOptions = true
                                        renameText = folder.name
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .shadow(radius: 1)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .confirmationDialog("Folder Options", isPresented: $showFolderOptions, titleVisibility: .visible) {
                Button("Rename") {
                    showRenameDialog = true
                }

                Button("Delete", role: .destructive) {
                    showDeleteConfirmation = true
                }

                Button("Cancel", role: .cancel) {}
            }
            .alert("Delete Folder?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let folder = selectedFolder {
                        favorites.deleteFolder(folder)
                        selectedFolder = nil
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this folder and remove all associated items?")
            }
            .alert("Rename Folder", isPresented: $showRenameDialog, actions: {
                TextField("Folder Name", text: $renameText)
                Button("Save") {
                    if let index = favorites.themeFolders.firstIndex(where: { $0.id == selectedFolder?.id }) {
                        favorites.renameFolder(at: index, to: renameText)
                    }
                }
                Button("Cancel", role: .cancel) {}
            })
        }
    }
}




