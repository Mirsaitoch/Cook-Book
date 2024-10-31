//
//  ProfileViewModel.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var aboutText = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isEditing = false
    @Published var showImagePicker = false
    @Published var showPasswordAlert = false
    @Published var isSaving = false
    @Published var profileImage: UIImage?

    private var storage = Storage.storage()
    private var db = Firestore.firestore()
    
    func fetchUserData() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.username = data?["username"] as? String ?? ""
                self.email = data?["email"] as? String ?? ""
                self.aboutText = data?["about"] as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func saveUserData() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userData: [String: Any] = [
            "username": self.username,
            "email": self.email,
            "about": self.aboutText,
            "profileImageUrl": "profileImages/\(uid).jpg"
        ]
        
        do {
            try await db.collection("users").document(uid).setData(userData)
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func uploadProfileImage(image: UIImage?) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        guard let image = image else {
            print("image is nil")
            return
        }
        
        let storageRef = storage.reference().child("profileImages/\(uid).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            return
        }
        
        do {
            print("Uploading image for UID: \(uid)")
            let _ = try await storageRef.putDataAsync(imageData, metadata: nil)
            let downloadURL = try await storageRef.downloadURL()
            print("Image uploaded successfully, URL: \(downloadURL)")
            await saveProfileImageURL(url: downloadURL.absoluteString)
        } catch {
            print("Error uploading image: \(error.localizedDescription)")
        }
    }
    
    private func saveProfileImageURL(url: String) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        do {
            print("Saving profile image URL for UID: \(uid)")
            try await db.collection("users").document(uid).updateData(["profileImageUrl": url])
            print("Profile image URL saved successfully")
        } catch {
            print("Error saving image URL: \(error.localizedDescription)")
        }
    }
    
    
    func fetchProfileImage() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let imageUrlString = data?["profileImageUrl"] as? String,
                   let url = URL(string: imageUrlString) {
                    self.downloadImage(from: url)
                }
            }
        }
    }
    
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.profileImage = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "No user logged in", code: -1, userInfo: nil)))
            return
        }
        
        let uid = user.uid
        
        user.delete { [weak self] error in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code), errCode == .requiresRecentLogin {
                    self?.reauthenticateUser(user: user) { result in
                        switch result {
                        case .success:
                            user.delete { error in
                                if let error = error {
                                    completion(.failure(error))
                                } else {
                                    self?.deleteUserData(uid: uid, completion: completion)
                                }
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(error))
                }
            } else {
                self?.deleteUserData(uid: uid, completion: completion)
            }
        }
    }
    
    private func deleteUserData(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let docRef = Firestore.firestore().collection("users").document(uid)
        
        docRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    private func reauthenticateUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let email = "user@example.com"
        let password = "password"
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func reauthenticateAndDeleteAccount(password: String, completion: @escaping (Result<Void, Error>) -> Void) async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(.failure(NSError(domain: "No user logged in or email not found", code: -1, userInfo: nil)))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user.reauthenticate(with: credential) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self?.deleteAccount(completion: completion)
        }
    }
    
    func logOut() throws {
        try Auth.auth().signOut()
    }
}
