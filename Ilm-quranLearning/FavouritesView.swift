//
//  FavouritesGridView.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 18/04/2025.
//

import SwiftUI

struct FavouritesView: View {
    let folder: FavouriteThemeFolder

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var favouritesStore: FavouritesStore

    var body: some View {
        GeometryReader { geo in
            let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
            let itemWidth = geo.size.width / 3

            VStack(spacing: 0) {
                // 🔝 Top Bar
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

                        Text("Favourites")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "D4B4AC"))

                        Spacer()
                        Spacer().frame(width: 32)
                    }
                    .padding(.vertical, 8)
                }
                .frame(height: 56)

                Text(folder.name)
                    .font(.subheadline)
                    .padding(.top, 10)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(folder.themes) { theme in
                            NavigationLink(
                                destination: KeyThemesDetailView(themes: folder.themes, selectedTheme: theme)
                                    .environmentObject(favouritesStore)
                            ) {
                                ZStack(alignment: .bottomTrailing) {
                                    Text(theme.translation)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(6)
                                        .multilineTextAlignment(.center)
                                        .padding(6)
                                        .frame(width: itemWidth, height: itemWidth)
                                        .background(Color.white)
                                        .border(Color.black, width: 0.5)

                                    Image(systemName: "heart.fill")
                                        .foregroundColor(Color(hex: "C33B76"))
                                        .padding(6)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}
