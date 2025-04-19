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
    @EnvironmentObject var favouritesStore: FavouritesStore
    @State private var hasLoaded = false

    var body: some View {
        GeometryReader { geo in
            let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
            let itemWidth = geo.size.width / 3

            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Color(hex: "722345").ignoresSafeArea(edges: .top)

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

                Text(surah)
                    .font(.subheadline)
                    .padding(.top, 10)

                if !hasLoaded {
                    ProgressView().onAppear {
                        favouritesStore.loadFoldersFromFirestore()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            hasLoaded = true
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(themes) { theme in
                                themeGridItem(theme: theme, itemWidth: itemWidth)
                            }
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
        ZStack(alignment: .bottomTrailing) {
            NavigationLink(
                destination: KeyThemesDetailView(themes: themes, selectedTheme: theme)
                    .environmentObject(favouritesStore)
            ) {
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

            if favouritesStore.isFavourited(theme) {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color(hex: "C33B76"))
                    .padding(6)
            }
        }
    }
}
