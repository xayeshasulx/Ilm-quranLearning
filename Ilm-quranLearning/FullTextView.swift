//
//  FullTextView.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 17/04/2025.
//
import SwiftUI

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
