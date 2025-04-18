//
//  SettingsView.swift
//  Ilm
//
//  Created by Ayesha Suleman on 23/03/2025.
//
import SwiftUI
import PhotosUI
import FirebaseAuth

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showLogin = false
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Bar
                ZStack {
                    Color(hex: "722345").ignoresSafeArea()
                    HStack {
                        Spacer()
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "D4B4AC"))
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .frame(height: 56)

                // Profile Image
                ZStack(alignment: .bottomTrailing) {
                    if let image = profileImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else if let url = viewModel.profileImageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView().frame(width: 120, height: 120)
                            case .success(let img):
                                img.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            default:
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray.opacity(0.6))
                                    .frame(width: 120, height: 120)
                            }
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.gray.opacity(0.6))
                            .frame(width: 120, height: 120)
                    }

                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        Image(systemName: "camera")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color(hex: "A46A79"))
                            .clipShape(Circle())
                    }
                    .onChange(of: selectedImage) {
                        Task {
                            if let data = try? await selectedImage?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                await MainActor.run {
                                    profileImage = Image(uiImage: uiImage)
                                }
                                await viewModel.saveProfileImage(data)
                            }
                        }
                    }
                }
                .padding(.top, 32)

                if profileImage != nil || viewModel.profileImageURL != nil {
                    Button("Remove Photo") {
                        profileImage = nil
                        selectedImage = nil
                        Task {
                            await viewModel.saveProfileImage(nil)
                        }
                    }
                    .foregroundColor(.red)
                    .padding(.top, 8)
                }

                // Greeting
                if !viewModel.username.isEmpty {
                    Text("As-salamu alaykum, \(viewModel.username)")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.top, 12)
                }

                Spacer()

                Button("Log Out") {
                    viewModel.logout()
                    showLogin = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "A46A79"))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)

                Spacer()
            }
            .background(Color.white.ignoresSafeArea())
            .fullScreenCover(isPresented: $showLogin) {
                LoginView()
            }
            .navigationBarHidden(true)
            .task {
                // Refresh user data on appear
                await viewModel.loadUserData()
            }
        }
    }
}


#Preview {
    SettingsView().environmentObject(AuthViewModel())
}




