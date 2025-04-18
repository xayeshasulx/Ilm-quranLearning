//
//  KeyThemesGridView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 14/04/2025.
//
import SwiftUI

struct KeyThemesGridView: View {
    let surah: String
    let themes: [KeyTheme]

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var favoritesStore: FavoritesStore

    var body: some View {
        GeometryReader { geo in
            let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
            let itemWidth = geo.size.width / 3

            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Color(hex: "722345")
                        .ignoresSafeArea(edges: .top)

                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
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

                Text(surah)
                    .font(.subheadline)
                    .padding(.top, 10)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(themes) { theme in
                            themeGridItem(theme: theme, itemWidth: itemWidth)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

    @ViewBuilder
    private func themeGridItem(theme: KeyTheme, itemWidth: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink(destination: KeyThemesDetailView(themes: themes, selectedTheme: theme)
                .environmentObject(favoritesStore)) {
                Text(theme.translation)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(6)
                    .multilineTextAlignment(.center)
                    .padding(6)
                    .frame(width: itemWidth, height: itemWidth)
                    .background(Color.white)
                    .border(Color.black, width: 0.5)
            }

            Button(action: {
                favoritesStore.toggleFavorite(theme, to: "Default")
            }) {
                Image(systemName: favoritesStore.isFavorited(theme) ? "heart.fill" : "heart")
                    .foregroundColor(Color(hex: "C33B76"))
                    .padding(6)
            }

        }
    }
}
