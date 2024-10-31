//
//  RecipeCell.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import Foundation
import SwiftUI

struct RecipeCell: View {
    var recipe: Recipe
    var deleteAction: (() -> Void)?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.inter(.interBold, size: 22))
                    .foregroundColor(.black)
                Text("Author: \(recipe.author)")
                    .font(.inter(.interMedium, size: 16))
                    .foregroundColor(.gray)
                Text(recipe.description)
                    .font(.inter(.interMedium, size: 18))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                    .lineLimit(2)
                Spacer()
                Text(recipe.cookingTime)
                    .font(.inter(.interMedium, size: 18))
                    .foregroundColor(.black)
            }
            Spacer()
            VStack {
                if let imageUrl = recipe.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        ProgressView()
                    }
                }
                if let deleteAction {
                    Image(systemName: "trash.circle")
                        .foregroundStyle(.red)
                        .font(.system(size: 24))
                        .onTapGesture {
                            deleteAction()
                        }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}
