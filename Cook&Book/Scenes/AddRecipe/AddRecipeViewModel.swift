//
//  AddRecipeViewModel.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 21.10.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import Foundation
import FirebaseAuth

extension AddRecipeView {
    class ViewModel: ObservableObject {
        private let db = Firestore.firestore()
        private let storage = Storage.storage()
        
        @Published var title = ""
        @Published var description = ""
        @Published var cookingTimeHours = 0
        @Published var cookingTimeMinutes = 0
        @Published var selectedIngredients = [String]()
        @Published var recipeText = ""
        @Published var showImagePicker = false
        @Published var recipeImage: UIImage?
        @Published var tryedToSaveRecipe = false
        
        let ingredients = [
            "Almonds", "Avocado", "Baking Powder", "Basil", "Bay Leaf", "Beef",
            "Bell Pepper", "Bread", "Broccoli", "Butter", "Carrot", "Cauliflower",
            "Celery", "Cheese", "Chicken", "Chili Powder", "Cinnamon", "Coconut Milk",
            "Coriander", "Cucumber", "Cumin", "Egg", "Eggplant", "Fish", "Flour",
            "Garlic", "Ginger", "Honey", "Lemon", "Lentils", "Lettuce", "Milk",
            "Mushroom", "Mustard", "Nutmeg", "Oats", "Oil", "Olive Oil", "Onion",
            "Orange", "Oregano", "Paprika", "Parsley", "Pasta", "Peas", "Pepper",
            "Pork", "Potato", "Rice", "Rosemary", "Salt", "Soy Sauce", "Spinach",
            "Sugar", "Thyme", "Tomato", "Turmeric", "Vinegar", "Yeast", "Yogurt",
            "Zucchini"
        ]
        
        func saveRecipe() {
            tryedToSaveRecipe = true
            guard let uid = Auth.auth().currentUser?.uid else {
                print("User not authenticated")
                return
            }
            
            guard !title.isEmpty, !description.isEmpty, !recipeText.isEmpty else {
                return
            }
            
            let cookingTime = "\(cookingTimeHours) h \(cookingTimeMinutes) min"
            let id = UUID().uuidString
            
            var recipeData: [String: Any] = [
                "id": id,
                "title": title,
                "cookingTime": cookingTime,
                "ingredients": selectedIngredients,
                "recipeText": recipeText,
                "description": description,
                "author": uid,
                "timestamp": Date().timeIntervalSince1970
            ]
            
            tryedToSaveRecipe = false
            
            if let imageData = recipeImage?.jpegData(compressionQuality: 0.8) {
                let storageRef = storage.reference().child("recipes/\(UUID().uuidString).jpg")
                
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print("Error getting download URL: \(error.localizedDescription)")
                            return
                        }
                        
                        if let imageUrl = url?.absoluteString {
                            recipeData["imageUrl"] = imageUrl
                            self.saveRecipeData(recipeData)
                        }
                    }
                }
            } else {
                saveRecipeData(recipeData)
            }
        }
        
        private func saveRecipeData(_ recipeData: [String: Any]) {
            db.collection("recipes").addDocument(data: recipeData) { error in
                if let error = error {
                    print("Error saving recipe: \(error.localizedDescription)")
                } else {
                    print("Recipe saved successfully!")
                }
            }
        }
    }
}

