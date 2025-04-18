//
//  KeyThemesDetailView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//
import SwiftUI

struct KeyThemesDetailView: View {
    let themes: [KeyTheme]
    let selectedTheme: KeyTheme

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var favorites: FavoritesStore

    @State private var expandedTheme: KeyTheme?
    @State private var currentIndex: Int = 0
    @State private var showFolderSheet = false
    @State private var folderName: String = ""
    @State private var selectedThemeForFolder: KeyTheme?
    @State private var themeForReflection: KeyTheme?

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(themes.indices, id: \.self) { index in
                            let theme = themes[index]

                            ZStack {
                                Color.white.ignoresSafeArea()

                                GeometryReader { innerGeo in
                                    VStack {
                                        Spacer()

                                        VStack(spacing: 20) {
                                            Text(theme.translation)
                                                .font(.body)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(shouldLimit(theme) ? 15 : nil)

                                            if shouldLimit(theme) {
                                                Button("Expand") {
                                                    expandedTheme = theme
                                                }
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "722345"))
                                            }
                                        }
                                        .padding(.horizontal, 20)

                                        Spacer()

                                        HStack(spacing: 20) {
                                            Button {
                                                themeForReflection = theme
                                            } label: {
                                                Image(systemName: "square.and.pencil")
                                                    .resizable()
                                                    .frame(width: 22, height: 24)
                                                    .foregroundColor(Color(hex: "722345"))
                                                    .padding(16)
                                                    .background(Color.white)
                                                    .clipShape(Circle())
                                                    .shadow(radius: 3)
                                            }

                                            Button {
                                                selectedThemeForFolder = theme
                                                showFolderSheet = true
                                            } label: {
                                                Image(systemName: favorites.isFavorited(theme) ? "heart.fill" : "heart")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(favorites.isFavorited(theme) ? Color(hex: "C33B76") : .gray)
                                                    .padding(16)
                                                    .background(Color.white)
                                                    .clipShape(Circle())
                                                    .shadow(radius: 3)
                                            }

                                            Button {
                                                shareTheme(theme)
                                            } label: {
                                                Image(systemName: "square.and.arrow.up")
                                                    .resizable()
                                                    .frame(width: 22, height: 24)
                                                    .foregroundColor(Color(hex: "722345"))
                                                    .padding(16)
                                                    .background(Color.white)
                                                    .clipShape(Circle())
                                                    .shadow(radius: 3)
                                            }
                                        }
                                        .padding(.bottom, 32)
                                    }
                                    .frame(width: innerGeo.size.width, height: innerGeo.size.height)
                                }
                            }
                            .frame(height: geo.size.height - 56)
                            .containerRelativeFrame(.vertical)
                            .id(index)
                        }
                    }
                    .scrollTargetLayout()
                    .onAppear {
                        if let selectedIndex = themes.firstIndex(of: selectedTheme) {
                            currentIndex = selectedIndex
                            proxy.scrollTo(currentIndex, anchor: .top)
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
                .overlay(alignment: .top) {
                    ZStack {
                        Color(hex: "722345").ignoresSafeArea()
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 16)

                            Spacer()

                            Text("Key Themes & Messages")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "D4B4AC"))

                            Spacer()
                            Spacer().frame(width: 32)
                        }
                        .padding(.vertical, 8)
                    }
                    .frame(height: 56)
                }
                .sheet(item: $expandedTheme) {
                    FullThemeView(theme: $0)
                }
                .sheet(item: $themeForReflection) { theme in
                    ReflectionEditorView(
                        prefilledTitle: "",
                        prefilledBody: "",
                        prefilledSourceText: theme.translation
                    )
                }
                .sheet(isPresented: $showFolderSheet) {
                    folderPicker
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    private func shouldLimit(_ theme: KeyTheme) -> Bool {
        theme.translation.count > 400
    }

    private func shareTheme(_ theme: KeyTheme) {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = scene.windows.first else {
            return
        }

        let activityVC = UIActivityViewController(activityItems: [theme.translation], applicationActivities: nil)
        window.rootViewController?.present(activityVC, animated: true)
    }

    var folderPicker: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Save to Folder")
                    .font(.headline)
                    .padding(.top)

                TextField("Enter folder name", text: $folderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Divider()

                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(favorites.themeFolders, id: \.id) { folder in
                            Button(action: {
                                if let theme = selectedThemeForFolder {
                                    favorites.toggleFavorite(theme, to: folder.name)
                                    showFolderSheet = false
                                    folderName = ""
                                }
                            }) {
                                Text(folder.name)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                Button("Save") {
                    if let theme = selectedThemeForFolder {
                        favorites.toggleFavorite(theme, to: folderName)
                        showFolderSheet = false
                        folderName = ""
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "722345"))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
            }
            .navigationTitle("Add to Folder")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct FullThemeView: View {
    let theme: KeyTheme
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Color(hex: "722345").ignoresSafeArea(edges: .top)

                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    Text("Full Key Theme")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    Spacer()
                    Spacer().frame(width: 32)
                }
                .padding(.vertical, 8)
            }
            .frame(height: 56)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(theme.translation)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                .padding()
            }
        }
    }
}





