//
//  ContentView.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 16/04/2025.
//
import SwiftUI

// MARK: - Custom EnvironmentKey for Tab Control
private struct SelectedTabKey: EnvironmentKey {
    static var defaultValue: Binding<Int> = .constant(0)
}

extension EnvironmentValues {
    var selectedTabIndex: Binding<Int> {
        get { self[SelectedTabKey.self] }
        set { self[SelectedTabKey.self] = newValue }
    }
}

// MARK: - Main App Shell
struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    @StateObject private var favoritesStore = FavouritesStore()
    @StateObject private var reflectionsStore = ReflectionsStore()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .navigationWrapper()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)

            FavouritesListView()
                .navigationWrapper()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favourites")
                }
                .tag(1)

            FeedView()
                .navigationWrapper()
                .tabItem {
                    Image(systemName: "text.justify")
                    Text("Feed")
                }
                .tag(2)

            ReflectionsListView()
                .navigationWrapper()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Reflections")
                }
                .tag(3)

            SettingsView()
                .navigationWrapper()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .tint(Color(hex: "722345"))
        .environment(\.horizontalSizeClass, .compact)
        .environmentObject(viewModel)
        .environmentObject(favoritesStore)
        .environmentObject(reflectionsStore)
        .environment(\.selectedTabIndex, $selectedTab) // ✅ Inject for external control
    }
}

// MARK: - Navigation Wrapper Helper
extension View {
    func navigationWrapper() -> some View {
        NavigationStack {
            self
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(FavouritesStore())
        .environmentObject(ReflectionsStore())
}

