//
//  LoginModel.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import Foundation

final class LogInModel: ObservableObject {
    @Published var email: String = ""
    @Published var password = ""
    @Published var errorText = ""

    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw LoginError.incorrectEmailOrPass
        }
        try await AuthManager.shared.signInUser(email: email.lowercased(), password: password)
    }
    
    func signInAnonymously() async throws {
        try await AuthManager.shared.signInAnonymously()
    }
}

enum LoginError: Error {
    case incorrectEmailOrPass
    case failedRegistation
    case noInternet
}

extension LoginError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectEmailOrPass:
            return "Incorrect username or password"
        case .noInternet:
            return "No internet"
        case .failedRegistation:
            return "Something went wrong"
        }
    }
}
