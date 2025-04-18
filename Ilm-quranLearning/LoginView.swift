import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isPasswordVisible = false
    @State private var navigateToRegister = false
    @State private var navigateToHome = false

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

                        Text("Sign in to your account")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Text("Continue your learning journey")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))

                        Group {
                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .foregroundColor(.black)
                                .accentColor(.black)

                            HStack {
                                if isPasswordVisible {
                                    TextField("Password", text: $viewModel.password)
                                        .keyboardType(.asciiCapable)
                                        .textContentType(.oneTimeCode)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .foregroundColor(.black)
                                        .accentColor(.black)
                                } else {
                                    SecureField("Password", text: $viewModel.password)
                                        .keyboardType(.asciiCapable)
                                        .textContentType(.oneTimeCode)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .foregroundColor(.black)
                                        .accentColor(.black)
                                }

                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                        }

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }

                        Button(action: {
                            Task {
                                await viewModel.login()
                                if viewModel.isSignedIn {
                                    navigateToHome = true
                                }
                            }
                        }) {
                            Text("Login")
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
                            Text("Don't have an account?")
                                .foregroundColor(.white.opacity(0.8))
                            Button("Sign up in here") {
                                navigateToRegister = true
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
                .navigationDestination(isPresented: $navigateToRegister) {
                    RegisterView()
                }
                .fullScreenCover(isPresented: $navigateToHome) {
                    ContentView()
                }
            }
        }
    }

    func passwordField(_ placeholder: String, text: Binding<String>, isVisible: Binding<Bool>) -> some View {
        HStack {
            if isVisible.wrappedValue {
                TextField(placeholder, text: text)
            } else {
                SecureField(placeholder, text: text)
            }
            Button(action: { isVisible.wrappedValue.toggle() }) {
                Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
    }
}


#Preview {
    NavigationView {
        LoginView()
    }
}



// maybe add forgot password only if neccasary
