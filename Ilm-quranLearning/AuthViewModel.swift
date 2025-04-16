//
// AuthViewModel.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 16/04/2025.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isSignedIn: Bool = false

    func register() async {
        guard await validateFields() else { return }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = result.user

            let userData: [String: Any] = [
                "username": username,
                "email": email,
                "createdAt": FieldValue.serverTimestamp()
            ]

            try await Firestore.firestore()
                .collection("users")
                .document(user.uid)
                .setData(userData)

            isSignedIn = true
            print("✅ Registered and saved to Firestore: \(user.uid)")

        } catch {
            if let errCode = AuthErrorCode(rawValue: (error as NSError).code) {
                switch errCode {
                case .emailAlreadyInUse:
                    errorMessage = "Email is already registered."
                case .invalidEmail:
                    errorMessage = "Please enter a valid email address."
                case .weakPassword:
                    errorMessage = "Password must be at least 6 characters."
                default:
                    errorMessage = error.localizedDescription
                }
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }




    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            isSignedIn = true
            print("✅ Logged in: \(result.user.uid)")

        } catch {
            if let errCode = AuthErrorCode(rawValue: (error as NSError).code) {
                switch errCode {
                case .wrongPassword:
                    errorMessage = "Incorrect password."
                case .invalidEmail:
                    errorMessage = "Invalid email address."
                case .userNotFound:
                    errorMessage = "Account not found."
                default:
                    errorMessage = error.localizedDescription
                }
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }



    private func validateFields() async -> Bool {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required."
            return false
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }

        guard email.contains("@"), email.contains(".") else {
            errorMessage = "Enter a valid email address."
            return false
        }

        let usernameExists = try? await Firestore.firestore()
            .collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments()

        if let docs = usernameExists, !docs.isEmpty {
            errorMessage = "Username is already taken."
            return false
        }

        return true
    }

    func reset() {
        username = ""
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = nil
    }
}

