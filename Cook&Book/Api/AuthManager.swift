//
//  AuthManager.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import Foundation
import FirebaseAuth

struct AuthResultModel {
    var uid: String
    var email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email ?? ""
    }
}

final class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
    func getAuthUser() throws -> AuthResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthResultModel(user: user)
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthResultModel {
        let authRes = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthResultModel(user: authRes.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthResultModel {
        let authRes = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthResultModel(user: authRes.user)
    }
    
    @discardableResult
    func signInAnonymously() async throws -> AuthResultModel {
        let authRes = try await Auth.auth().signInAnonymously()
        return AuthResultModel(user: authRes.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
