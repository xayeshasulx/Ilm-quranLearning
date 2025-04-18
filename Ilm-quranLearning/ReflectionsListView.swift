//
//  ReflectionsListView.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 17/04/2025.
//
import SwiftUI

struct ReflectionsListView: View {
    @EnvironmentObject var reflectionsStore: ReflectionsStore
    @State private var navigateToCreate = false
    @State private var selectedReflection: Reflection?
    @State private var reflectionToDelete: Reflection?
    @State private var showDeleteAlert = false
    
    private var sortedReflections: [Reflection] {
        reflectionsStore.reflections.sorted { $0.timestamp > $1.timestamp }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 🔝 Top Bar
                ZStack(alignment: .center) {
                    Color(hex: "722345").ignoresSafeArea(edges: .top)
                    
                    Text("Reflections")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "D4B4AC"))
                }
                .frame(height: 56)
                
                // 🧾 Reflections List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(sortedReflections) { reflection in
                            reflectionCard(reflection)
                                .onTapGesture {
                                    selectedReflection = reflection
                                }
                        }
                    }
                    .padding(.top)
                }
                
                // Create New Button
                Button(action: {
                    navigateToCreate = true
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "A46A79"))
                                .frame(width: 60, height: 60)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        Text("Create New")
                            .font(.footnote)
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 16)
            }
            .navigationDestination(isPresented: $navigateToCreate) {
                ReflectionCreateNewView()
            }
            .navigationDestination(item: $selectedReflection) { reflection in
                ReflectionsView(reflection: reflection)
            }
            .onAppear {
                reflectionsStore.fetchReflections()
            }
            .alert("Delete Reflection?", isPresented: $showDeleteAlert, presenting: reflectionToDelete) { reflection in
                Button("Delete", role: .destructive) {
                    reflectionsStore.delete(reflection) { _ in }
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("Are you sure you want to delete this reflection?")
            }
        }
    }
    
    @ViewBuilder
    private func reflectionCard(_ reflection: Reflection) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: "A46A79"))
                .frame(width: 15)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reflection.title.isEmpty ? "Untitled" : reflection.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                Text(reflection.body.isEmpty ? "Untitled" : reflection.body)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(reflection.timestamp, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                reflectionToDelete = reflection
                showDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .padding(.trailing, 12)
        }
        .background(Color(hex: "D4B4AC"))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}



