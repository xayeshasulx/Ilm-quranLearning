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
    @EnvironmentObject var favourites: FavouritesStore

    @State private var expandedTheme: KeyTheme?
    @State private var currentIndex: Int = 0
    @State private var selectedThemeForFolder: KeyTheme?
    @State private var themeForReflection: KeyTheme?

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(themes.indices, id: \.self) { index in
                            themeCard(for: themes[index], index: index, geo: geo)
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
                    topBar
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
                .sheet(item: $selectedThemeForFolder) { theme in
                    FavouritesCreatedView(theme: theme)
                        .environmentObject(favourites)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    private func themeCard(for theme: KeyTheme, index: Int, geo: GeometryProxy) -> some View {
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

                    actionButtons(for: theme)
                        .padding(.bottom, 32)
                }
                .frame(width: innerGeo.size.width, height: innerGeo.size.height)
            }
        }
        .frame(height: geo.size.height - 56)
        .containerRelativeFrame(.vertical)
        .id(index)
    }

    private func actionButtons(for theme: KeyTheme) -> some View {
        HStack(spacing: 20) {
            Button {
                themeForReflection = theme
            } label: {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(hex: "722345"))
                    .padding(16)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }

            Button {
                if favourites.isFavourited(theme) {
                    favourites.removeFromFavourites(theme)
                } else {
                    selectedThemeForFolder = theme
                }
            } label: {
                Image(systemName: favourites.isFavourited(theme) ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(favourites.isFavourited(theme) ? Color(hex: "C33B76") : .gray)
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
    }

    private var topBar: some View {
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
}

// MARK: - Full View Modal
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
