//
//  ReflectionEditorView.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 17/04/2025.
//
import SwiftUI

struct ReflectionEditorView: View, Identifiable {
    let id = UUID()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var reflectionsStore: ReflectionsStore

    let prefilledTitle: String
    let prefilledBody: String
    let prefilledSourceText: String?
    var reflectionId: String? = nil

    @State private var title: String = ""
    @State private var bodyText: String = ""
    @State private var isSaving: Bool = false
    @State private var showError: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
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
                .padding(.vertical, 8)
            }
            .frame(height: 56)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if let source = prefilledSourceText, !source.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Post:")
                                .font(.footnote)
                                .foregroundColor(.secondary)

                            Text(source)
                                .padding()
                                .background(Color(hex: "D4B4AC"))
                                .cornerRadius(8)
                                .padding(.bottom, 16)
                        }
                    }

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
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                }
                .padding()
            }
        }
        .onAppear {
            self.title = prefilledTitle
            self.bodyText = prefilledBody
        }
        .alert("Failed to save reflection.", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        }
    }

    private func saveReflection() {
        isSaving = true

        let safeTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Untitled" : title
        let safeBody = bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Untitled" : bodyText

        let reflection = Reflection(
            id: reflectionId ?? UUID().uuidString,
            title: safeTitle,
            body: safeBody,
            timestamp: Date(),
            sourceText: prefilledSourceText
        )

        reflectionsStore.save(reflection) { success in
            isSaving = false
            success ? dismiss() : (showError = true)
        }
    }
}










