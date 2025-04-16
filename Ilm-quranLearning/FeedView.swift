//
//  FeedView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 23/03/2025.
//
import SwiftUI

struct FeedView: View {
    @ObservedObject var keyVersesVM = KeyVersesViewModel()
    @ObservedObject var ayahInsightsVM = AyahInsightsViewModel()
    @ObservedObject var keyThemesVM = KeyThemesViewModel()
    @ObservedObject var surahOverviewVM = SurahOverviewViewModel()
    @ObservedObject var supplicationsVM = QuranicSupplicationsViewModel()
    @ObservedObject var arabicWordsVM = ArabicWordsViewModel()

    @State private var shuffledFeed: [FeedItem] = []
    @State private var expandedItem: FeedItem?

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(shuffledFeed.indices, id: \.self) { index in
                        let item = shuffledFeed[index]

                        ZStack {
                            Color.white.ignoresSafeArea()

                            GeometryReader { _ in
                                VStack(spacing: 24) {
                                    VStack(spacing: 4) {
                                        Text(item.categoryLabel)
                                            .font(.headline)
                                            .foregroundColor(Color(hex: "A46A79"))
                                            .fontWeight(.medium)

                                        if !item.surahName.isEmpty {
                                            Text(item.surahName)
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "A46A79"))
                                        }
                                    }

                                    if let verse = item.keyVerse {
                                        verseView(verse)
                                    } else if let insight = item.ayahInsight {
                                        insightView(insight)
                                    } else if let supp = item.quranicSupplication {
                                        supplicationView(supp)
                                    } else if let word = item.arabicWord {
                                        arabicWordView(word)
                                    } else {
                                        textBlock(item.plainText)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 56)
                                .padding(.bottom, 40)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .frame(height: geo.size.height - 56)
                        .containerRelativeFrame(.vertical)
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
            .overlay(alignment: .top) {
                ZStack {
                    Color(hex: "722345").ignoresSafeArea()
                    HStack {
                        Button(action: generateShuffledFeed) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 16)

                        Spacer()

                        Text("Feed")
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
            .onAppear(perform: generateShuffledFeed)
            .sheet(item: $expandedItem) { item in
                if let verse = item.keyVerse {
                    FullVerseView(verse: verse)
                } else {
                    FullTextView(title: item.categoryLabel, text: item.plainText)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    func generateShuffledFeed() {
        var allItems: [FeedItem] = []

        for post in keyVersesVM.allSurahs {
            allItems += post.posts.map {
                FeedItem(keyVerse: $0, surahName: post.surah, categoryLabel: "Key Verses")
            }
        }

        for post in ayahInsightsVM.allSurahs {
            allItems += post.posts.map {
                FeedItem(ayahInsight: $0, surahName: post.surah, categoryLabel: "Ayah Insights")
            }
        }

        for post in keyThemesVM.allSurahs {
            allItems += post.posts.map {
                FeedItem(keyTheme: $0, surahName: post.surah, categoryLabel: "Key Themes & Messages")
            }
        }

        for post in surahOverviewVM.allSurahs {
            allItems += post.posts.map {
                FeedItem(surahOverview: $0, surahName: post.surah, categoryLabel: "Surah Overview")
            }
        }

        allItems += supplicationsVM.supplications.map {
            FeedItem(quranicSupplication: $0, categoryLabel: "Quranic Supplications")
        }

        allItems += arabicWordsVM.words.map {
            FeedItem(arabicWord: $0, categoryLabel: "Arabic Words")
        }

        shuffledFeed = allItems.shuffled()
    }

    @ViewBuilder
    func verseView(_ verse: KeyVerse) -> some View {
        VStack(spacing: 20) {
            Text(verse.title).font(.title3).fontWeight(.semibold).multilineTextAlignment(.center)
            Text(verse.arabic).font(.title).multilineTextAlignment(.center)
            Text(verse.transliteration).italic().foregroundColor(.gray)
            expandableText(verse.translation) {
                expandedItem = FeedItem(keyVerse: verse)
            }
        }
    }

    @ViewBuilder
    func insightView(_ insight: AyahInsight) -> some View {
        VStack(spacing: 20) {
            Text(insight.title).font(.title3).fontWeight(.semibold).multilineTextAlignment(.center)
            expandableText(insight.translation) {
                expandedItem = FeedItem(ayahInsight: insight)
            }
        }
    }

    @ViewBuilder
    func supplicationView(_ supp: QuranicSupplication) -> some View {
        VStack(spacing: 20) {
            Text(supp.reference).font(.title3).fontWeight(.semibold).multilineTextAlignment(.center)
            Text(supp.arabic).font(.title).multilineTextAlignment(.center)
            Text(supp.transliteration).italic().foregroundColor(.gray)
            expandableText(supp.translation) {
                expandedItem = FeedItem(quranicSupplication: supp)
            }
            if !supp.notes.isEmpty {
                Text(supp.notes).font(.footnote).foregroundColor(.secondary)
            }
        }
    }

    @ViewBuilder
    func arabicWordView(_ word: ArabicWord) -> some View {
        VStack(spacing: 20) {
            Text(word.arabic).font(.title).multilineTextAlignment(.center)
            Text(word.transliteration).italic().foregroundColor(.gray)
            expandableText(word.translation) {
                expandedItem = FeedItem(arabicWord: word)
            }
            if !word.occurrences.isEmpty {
                Text("Occurrences: \(word.occurrences)").font(.footnote).foregroundColor(.secondary)
            }
        }
    }

    @ViewBuilder
    func textBlock(_ text: String) -> some View {
        expandableText(text) {
            expandedItem = FeedItem(text: text)
        }
    }

    @ViewBuilder
    func expandableText(_ text: String, action: @escaping () -> Void) -> some View {
        let isLong = text.count > 350
        if isLong {
            VStack(spacing: 12) {
                Text(text).font(.body).lineLimit(6).multilineTextAlignment(.leading)
                Button("Expand", action: action)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "722345"))
            }
        } else {
            Text(text).font(.body).multilineTextAlignment(.leading)
        }
    }
}

// MARK: - FeedItem

struct FeedItem: Identifiable, Equatable {
    var id = UUID()

    var keyVerse: KeyVerse?
    var ayahInsight: AyahInsight?
    var keyTheme: KeyTheme?
    var surahOverview: SurahOverview?
    var quranicSupplication: QuranicSupplication?
    var arabicWord: ArabicWord?
    var text: String?

    var surahName: String = ""
    var categoryLabel: String = ""

    var plainText: String {
        if let text = text { return text }
        if let ayahInsight = ayahInsight { return ayahInsight.translation }
        if let keyTheme = keyTheme { return keyTheme.translation }
        if let surahOverview = surahOverview { return surahOverview.translation }
        if let quranicSupplication = quranicSupplication { return quranicSupplication.translation }
        if let arabicWord = arabicWord { return arabicWord.translation }
        return ""
    }

    static func ==(lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct FullTextView: View {
    var title: String
    var text: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Color(hex: "722345").ignoresSafeArea(edges: .top)

                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    Text("Full Text")
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
                VStack(alignment: .leading, spacing: 24) {
                    Text(text)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                .padding(20)
            }
        }
    }
}






#Preview {
    FeedView()
}
