//
//  Recipe.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 21.10.2024.
//

import SwiftUI

struct Recipe: Identifiable, Codable, Hashable {
    var id: String?
    var author: String
    var title: String
    var description: String
    var cookingTime: String
    var ingredients: [String]
    var recipeText: String
    var imageUrl: String?
    var timestamp: Double
}
