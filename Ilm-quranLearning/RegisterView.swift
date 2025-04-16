//
//  RegisterView.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 16/04/2025.
//
import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var navigateToLogin = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 20) {
                        Image("app_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(.top, 40)

                        Text("Let’s create your account")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Text("Begin your path to learning")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))

                        Group {
                            TextField("Username", text: $viewModel.username)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .foregroundColor(.black)
                                .accentColor(.black)

                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .foregroundColor(.black)
                                .accentColor(.black)

                            passwordField("Password", text: $viewModel.password, isVisible: $isPasswordVisible)
                            passwordField("Confirm Password", text: $viewModel.confirmPassword, isVisible: $isConfirmPasswordVisible)
                        }

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }

                        Button(action: {
                            Task {
                                await viewModel.register()
                                if viewModel.isSignedIn {
                                    dismiss() // 👈 back to LoginView
                                }
                            }
                        }) {
                            Text("Sign Up")
                                .frame(width: 200)
                                .padding()
                                .background(Color(hex: "A46A79"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                        Divider()
                            .background(.white.opacity(0.4))
                            .padding(.vertical, 10)

                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.white.opacity(0.8))
                            Button("Log in here") {
                                navigateToLogin = true
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(.bottom, 30)
                    }
                    .padding()
                    .frame(minHeight: geometry.size.height)
                }
                .background(Color(hex: "722345"))
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
    }

    func passwordField(_ placeholder: String, text: Binding<String>, isVisible: Binding<Bool>) -> some View {
        HStack {
            Group {
                if isVisible.wrappedValue {
                    TextField(placeholder, text: text)
                } else {
                    SecureField(placeholder, text: text)
                }
            }
            .textContentType(.oneTimeCode)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .foregroundColor(.black)
            .accentColor(.black)

            Button(action: { isVisible.wrappedValue.toggle() }) {
                Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
}


#Preview {
    NavigationView {
        RegisterView()
    }
}


// maybe add continue with apple later
