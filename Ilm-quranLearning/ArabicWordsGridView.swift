//
//  ArabicWordsGridView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 15/04/2025.
//
import SwiftUI

struct ArabicWordsGridView: View {
    @StateObject private var viewModel = ArabicWordsViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geo in
            let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
            let itemWidth = geo.size.width / 3

            VStack(spacing: 0) {
                // Top Bar
                ZStack(alignment: .bottom) {
                    Color(hex: "722345").ignoresSafeArea(edges: .top)
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 16)

                        Spacer()

                        Text("Arabic Words")
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
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(viewModel.words) { word in
                            wordGridItem(word: word, itemWidth: itemWidth)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

    @ViewBuilder
    private func wordGridItem(word: ArabicWord, itemWidth: CGFloat) -> some View {
        NavigationLink(destination: ArabicWordsDetailView(words: viewModel.words, selected: word)) {
            VStack(spacing: 0) {
                Text(word.arabic)
                    .font(.title3)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(4)

                Text(word.translation)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(4)
                    .multilineTextAlignment(.center)
                    .padding(6)
            }
            .frame(width: itemWidth, height: itemWidth)
            .background(Color.white)
            .border(Color.black, width: 0.5)
        }
    }
}

