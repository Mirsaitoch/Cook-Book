//
//  MainViewModel.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

extension MainView {
    class ViewModel: ObservableObject {
        @Published var isShowPlusScreen: Bool = false
        @Published var goToProfile: Bool = false
        @Published var presentMode: presentMode = .all
        @Published var allRecipes: [Recipe] = []
        @Published var personalRecipes: [Recipe] = []
        
        private let db = Firestore.firestore()
        
        init() {
            startListeningForAllRecipes()
            startListeningForPersonalRecipes()
        }
        
        func fetchAllRecipes() {
            db.collection("recipes")
                .order(by: "timestamp", descending: true)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error fetching all recipes: \(error.localizedDescription)")
                        return
                    }
                    
                    if let snapshot = snapshot {
                        var recipes = [Recipe]()
                        let group = DispatchGroup()
                        
                        for document in snapshot.documents {
                            do {
                                var recipe = try document.data(as: Recipe.self)
                                let authorId = recipe.author
                                group.enter()
                                self.fetchUsername(for: authorId) { username in
                                    recipe.author = username ?? "Unknown Author"
                                    recipes.append(recipe)
                                    group.leave()
                                }
                                
                            } catch {
                                print("Error decoding recipe: \(error)")
                            }
                        }
                        
                        group.notify(queue: .main) {
                            self.allRecipes = recipes
                        }
                    }
                }
        }
        
        
        func fetchPersonalRecipes() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            print(uid)
            db.collection("recipes")
                .whereField("author", isEqualTo: uid)
                .order(by: "timestamp", descending: true)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error fetching personal recipes: \(error.localizedDescription)")
                        return
                    }
                    
                    if let snapshot = snapshot {
                        var personalRecipes = [Recipe]()
                        let group = DispatchGroup()
                        for document in snapshot.documents {
                            do {
                                var recipe = try document.data(as: Recipe.self)
                                let authorId = recipe.author
                                group.enter()
                                self.fetchUsername(for: authorId) { username in
                                    recipe.author = username ?? "Unknown Author"
                                    personalRecipes.append(recipe)
                                    group.leave()
                                }
                                
                            } catch {
                                print("Error decoding recipe: \(error)")
                            }
                        }
                        
                        group.notify(queue: .main) {
                            self.personalRecipes = personalRecipes
                        }
                    }
                }
        }
        
        func fetchUsername(for userId: String, completion: @escaping (String?) -> Void) {
            db.collection("users").document(userId).getDocument { (document, error) in
                if let error = error {
                    print("Error fetching username: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let document = document, document.exists, let data = document.data() {
                    let username = data["username"] as? String
                    completion(username)
                } else {
                    completion(nil)
                }
            }
        }
        
        func startListeningForAllRecipes() {
            db.collection("recipes")
                .order(by: "timestamp", descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        print("Error listening for all recipes: \(error.localizedDescription)")
                        return
                    }
                    
                    if let snapshot = snapshot {
                        var recipes = [Recipe]()
                        let group = DispatchGroup()
                        
                        for document in snapshot.documents {
                            do {
                                var recipe = try document.data(as: Recipe.self)
                                let authorId = recipe.author
                                group.enter()
                                self.fetchUsername(for: authorId) { username in
                                    recipe.author = username ?? "Unknown Author"
                                    recipes.append(recipe)
                                    group.leave()
                                }
                                
                            } catch {
                                print("Error decoding recipe: \(error)")
                            }
                        }
                        
                        group.notify(queue: .main) {
                            self.allRecipes = recipes
                        }
                    }
                }
        }
        
        func startListeningForPersonalRecipes() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            db.collection("recipes")
                .whereField("author", isEqualTo: uid)
                .order(by: "timestamp", descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        print("Error listening for personal recipes: \(error.localizedDescription)")
                        return
                    }
                    
                    if let snapshot = snapshot {
                        var personalRecipes = [Recipe]()
                        let group = DispatchGroup()
                        
                        for document in snapshot.documents {
                            do {
                                var recipe = try document.data(as: Recipe.self)
                                let authorId = recipe.author
                                group.enter()
                                self.fetchUsername(for: authorId) { username in
                                    recipe.author = username ?? "Unknown Author"
                                    personalRecipes.append(recipe)
                                    group.leave()
                                }
                                
                            } catch {
                                print("Error decoding recipe: \(error)")
                            }
                        }
                        
                        group.notify(queue: .main) {
                            self.personalRecipes = personalRecipes
                        }
                    }
                }
        }
        
        func deleteRecipe(_ recipe: Recipe) {
            guard let recipeId = recipe.id else {
                print("Error: Recipe ID is missing.")
                return
            }
            
            db.collection("recipes").whereField("id", isEqualTo: recipeId).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete { error in
                            if let error = error {
                                print("Error deleting recipe: \(error.localizedDescription)")
                            } else {
                                print("Recipe successfully deleted.")
                                self.allRecipes.removeAll { $0.id == recipeId }
                                self.personalRecipes.removeAll { $0.id == recipeId }
                            }
                        }
                    }
                }
            }
        }
    }
}

