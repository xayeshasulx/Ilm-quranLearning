//
//  PostDetailView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 10/04/2025.
//
import SwiftUI

struct KeyVersesDetailView: View {
    let verses: [KeyVerse]
    let selectedVerse: KeyVerse
    @Environment(\.presentationMode) var presentationMode
    @State private var expandedVerse: KeyVerse?
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(verses.indices, id: \.self) { index in
                            let verse = verses[index]

                            ZStack {
                                Color.white.ignoresSafeArea()

                                VStack(spacing: 24) {
                                    VStack(spacing: 20) {
                                        Text(verse.title)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .multilineTextAlignment(.center)

                                        Text(verse.arabic)
                                            .font(.title)
                                            .multilineTextAlignment(.center)

                                        Text(verse.transliteration)
                                            .italic()
                                            .foregroundColor(.gray)

                                        let isLong = verse.translation.count > 200

                                        Group {
                                            if isLong {
                                                Text(verse.translation)
                                                    .font(.body)
                                                    .lineLimit(4)
                                                    .multilineTextAlignment(.leading)

                                                Button("Expand") {
                                                    expandedVerse = verse
                                                }
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "722345"))
                                            } else {
                                                Text(verse.translation)
                                                    .font(.body)
                                                    .multilineTextAlignment(.leading)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.top, 56)
                                .padding(.bottom, 40)
                            }
                            .frame(height: geo.size.height - 56)
                            .containerRelativeFrame(.vertical)
                            .id(index)
                        }
                    }
                    .scrollTargetLayout()
                    .onAppear {
                        if let selectedIndex = verses.firstIndex(of: selectedVerse) {
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

                            Text("Key Verses")
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
                .sheet(item: $expandedVerse) { verse in
                    FullVerseView(verse: verse)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct FullVerseView: View {
    let verse: KeyVerse
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
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

                    Text("Full Verse")
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
                    Text(verse.title).font(.title3).bold()
                    Text(verse.arabic).font(.title)
                    Text(verse.transliteration).italic().foregroundColor(.gray)
                    Text(verse.translation).font(.body)
                }
                .padding()
            }
        }
    }
}










