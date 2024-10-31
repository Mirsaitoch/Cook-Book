//
//  SignUpViewModel.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

extension SignupView {
    class ViewModel: ObservableObject {
        @Published var username = ""
        @Published var email = ""
        @Published var password = ""
        @Published var confirmPass = ""
        @Published var errorText = ""
        var aboutText = ""

        @MainActor
        func register() async {
            guard email != "" && password != "" && confirmPass != "" && username != "" else {
                self.errorText = "Fill in all the data"
                return
            }
            
            guard isValidEmail(email) else {
                self.errorText = "Enter the correct email"
                return
            }
            
            guard password == confirmPass else {
                self.errorText = "Passwords don't match"
                return
            }

            do {
                let authResult = try await Auth.auth().createUserAsync(withEmail: email, password: password)
                let uid = authResult.user.uid
                
                self.errorText = ""
                
                let userData: [String: Any] = [
                    "username": self.username,
                    "email": self.email,
                    "about": self.aboutText
                ]
                
                try await Firestore.firestore().collection("users").document(uid).setDataAsync(userData)
            } catch {
                self.errorText = error.localizedDescription
                print(error.localizedDescription)
            }
        }
        
        private func isValidEmail(_ email: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
    }
}

extension Auth {
    func createUserAsync(withEmail email: String, password: String) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<AuthDataResult, Error>) in
            self.createUser(withEmail: email.lowercased(), password: password) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let authResult = authResult {
                    continuation.resume(returning: authResult)
                } else {
                    continuation.resume(throwing: NSError(domain: "UnknownError", code: -1, userInfo: nil))
                }
            }
        }
    }
}

extension DocumentReference {
    func setDataAsync(_ documentData: [String: Any]) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.setData(documentData) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
