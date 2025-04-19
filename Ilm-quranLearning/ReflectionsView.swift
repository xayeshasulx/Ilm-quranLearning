//
//  ReflectionsView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 23/03/2025.
//
import SwiftUI

struct ReflectionsView: View {
    var reflection: Reflection

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var reflectionsStore: ReflectionsStore

    @State private var title: String = ""
    @State private var bodyText: String = ""
    @State private var isSaving = false
    @State private var showError = false

    var body: some View {
        VStack(spacing: 0) {
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

                    Text("Edit Reflection")
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
                    if let source = reflection.sourceText, !source.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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

                    TextEditor(text: $bodyText)
                        .frame(minHeight: 200)
                        .padding(.top, 8)

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
        .onAppear {
            title = reflection.title
            bodyText = reflection.body
        }
        .alert("Failed to save reflection.", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        }
    }

    private func saveReflection() {
        isSaving = true

        let safeTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Untitled" : title
        let safeBody = bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Untitled" : bodyText

        let updated = Reflection(
            id: reflection.id,
            title: safeTitle,
            body: safeBody,
            timestamp: Date(),
            sourceText: reflection.sourceText
        )

        reflectionsStore.save(updated) { success in
            isSaving = false
            success ? dismiss() : (showError = true)
        }
    }
}








