//
//  ReflectionCreateNewView.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 17/04/2025.
//
import SwiftUI

struct ReflectionCreateNewView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var reflectionsStore: ReflectionsStore

    @State private var title: String = ""
    @State private var bodyText: String = ""
    @State private var isSaving = false
    @State private var showError = false

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
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

                    Text("New Reflection")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))

                    Spacer()
                    Spacer().frame(width: 32)
                }
                .padding(.bottom, 8)
            }
            .frame(height: 56)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    TextField("Title", text: $title)
                        .font(.title2)
                        .padding(.bottom, 4)

                    Divider()

                    ZStack(alignment: .topLeading) {
                        if bodyText.isEmpty {
                            Text("Type here...")
                                .foregroundColor(.gray)
                                .padding(.top, 18)
                                .padding(.horizontal, 6)
                        }

                        TextEditor(text: $bodyText)
                            .padding(.top, 8)
                            .opacity(bodyText.isEmpty ? 0.85 : 1)
                    }
                    .frame(minHeight: 300)

                    HStack {
                        Button(action: saveReflection) {
                            if isSaving {
                                ProgressView()
                                    .frame(width: 300)
                                    .padding()
                                    .background(Color(hex: "A46A79"))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            } else {
                                Text("Save Reflection")
                                    .frame(width: 300)
                                    .padding()
                                    .background(Color(hex: "A46A79"))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                        .disabled(isSaving)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                }
                .padding()
            }
        }
        .alert("Failed to save reflection.", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        }
    }

    private func saveReflection() {
        isSaving = true

        let safeTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Untitled" : title
        let safeBody = bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Untitled" : bodyText

        let newReflection = Reflection(
            id: UUID().uuidString,
            title: safeTitle,
            body: safeBody,
            timestamp: Date()
        )

        reflectionsStore.save(newReflection) { success in
            isSaving = false
            success ? dismiss() : (showError = true)
        }
    }
}




