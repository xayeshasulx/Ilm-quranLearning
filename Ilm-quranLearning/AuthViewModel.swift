//
// AuthViewModel.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 16/04/2025.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

@MainActor
class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isSignedIn: Bool = false
    @Published var profileImageURL: URL?

    init() {
        self.isSignedIn = Auth.auth().currentUser != nil
        if isSignedIn {
            Task {
                await loadUserData()
            }
        }
    }

    func register() async {
        guard await validateFields() else { return }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = result.user

            // Firestore data needs to be constructed on the MainActor
            let userData: [String: Any] = [
                "username": username,
                "email": email,
                "createdAt": FieldValue.serverTimestamp(),
                "profileImageURL": ""
            ]

            try await Firestore.firestore()
                .collection("users")
                .document(user.uid)
                .setData(userData)

            isSignedIn = true
            print("✅ Registered: \(user.uid)")
        } catch {
            handleAuthError(error)
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
            await loadUserData()
        } catch {
            handleAuthError(error)
        }
    }

    func loadUserData() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument()

            guard let data = snapshot.data() else { return }

            let username = data["username"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let urlString = data["profileImageURL"] as? String ?? ""

            await MainActor.run {
                self.username = username
                self.email = email
                self.profileImageURL = URL(string: urlString)
            }
        } catch {
            print("❌ Failed to load user data: \(error.localizedDescription)")
        }
    }

    func saveProfileImage(_ data: Data?) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let storageRef = Storage.storage().reference().child("profile_images/\(uid).jpg")

        do {
            if let imageData = data {
                _ = try await storageRef.putDataAsync(imageData)
                let downloadURL = try await storageRef.downloadURL()

                // ✅ Construct dictionary on MainActor
                let update: [String: Any] = await MainActor.run {
                    self.profileImageURL = downloadURL
                    return ["profileImageURL": downloadURL.absoluteString]
                }

                try await Firestore.firestore()
                    .collection("users")
                    .document(uid)
                    .updateData(update)

            } else {
                // ✅ Create dictionary with FieldValue on MainActor
                let deleteUpdate: [String: Any] = await MainActor.run {
                    self.profileImageURL = nil
                    return ["profileImageURL": FieldValue.delete()]
                }

                try await Firestore.firestore()
                    .collection("users")
                    .document(uid)
                    .updateData(deleteUpdate)
            }

        } catch {
            print("❌ Failed to save profile image: \(error.localizedDescription)")
        }
    }



    func logout() {
        try? Auth.auth().signOut()
        isSignedIn = false
        reset()
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

        let snapshot = try? await Firestore.firestore()
            .collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments()

        if let docs = snapshot, !docs.isEmpty {
            errorMessage = "Username is already taken."
            return false
        }

        return true
    }

    private func handleAuthError(_ error: Error) {
        if let errCode = AuthErrorCode(rawValue: (error as NSError).code) {
            switch errCode {
            case .emailAlreadyInUse:
                errorMessage = "Email is already registered."
            case .invalidEmail:
                errorMessage = "Please enter a valid email address."
            case .weakPassword:
                errorMessage = "Password must be at least 6 characters."
            case .wrongPassword:
                errorMessage = "Incorrect password."
            case .userNotFound:
                errorMessage = "No account found with this email."
            case .userDisabled:
                errorMessage = "This account has been disabled."
            case .tooManyRequests:
                errorMessage = "Too many attempts. Try again later."
            case .networkError:
                errorMessage = "Network connection error. Please try again."
            default:
                errorMessage = "Login failed: \(error.localizedDescription)"
            }
        } else {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }

    func reset() {
        username = ""
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = nil
        profileImageURL = nil
    }
}

private struct FirestoreUpdate: @unchecked Sendable {
    let key: String
    let value: Any

    var dictionary: [String: Any] {
        [key: value]
    }
}

