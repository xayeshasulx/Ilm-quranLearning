//
//  SettingsView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 23/03/2025.
//
import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top bar
                ZStack {
                    Color(hex: "722345").ignoresSafeArea()
                    HStack {
                        Spacer()

                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "D4B4AC"))

                        Spacer()
                        Spacer().frame(width: 32)
                    }
                    .padding(.vertical, 8)
                }
                .frame(height: 56)

                // Body content
                Spacer()

                Button(action: {
                    try? Auth.auth().signOut()
                    navigateToLogin = true
                }) {
                    Text("Log Out")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "A46A79"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }

                Spacer()
            }
            .background(Color.white.ignoresSafeArea())
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SettingsView()
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

