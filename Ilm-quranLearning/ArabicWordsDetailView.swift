//
//  ArabicWordsDetailView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 15/04/2025.
//
import SwiftUI

struct ArabicWordsDetailView: View {
    let words: [ArabicWord]
    let selected: ArabicWord

    @Environment(\.presentationMode) var presentationMode
    @State private var expanded: ArabicWord?
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(words.indices, id: \.self) { index in
                            let word = words[index]

                            ZStack {
                                Color.white.ignoresSafeArea()

                                VStack(spacing: 24) {
                                    VStack(spacing: 20) {
                                        Text(word.arabic)
                                            .font(.largeTitle)
                                            .fontWeight(.semibold)

                                        Text(word.transliteration)
                                            .italic()
                                            .foregroundColor(.gray)

                                        Text(word.translation)
                                            .font(.body)
                                            .multilineTextAlignment(.center)

                                        Text(word.occurrences)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
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
                        if let selectedIndex = words.firstIndex(of: selected) {
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
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

