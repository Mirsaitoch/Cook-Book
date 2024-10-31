//
//  RecipeDetailView.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 21.10.2024.
//

import SwiftUI
import FirebaseFirestore

struct RecipeDetailView: View {
    @State var recipe: Recipe
    @Environment(\.dismiss) var dismiss
    
    private let db = Firestore.firestore()
    
    var body: some View {
        ZStack {
            VStack {
                if let imageUrl = recipe.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: UIScreen.main.bounds.height * 0.4)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image("table")
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.main.bounds.height * 0.4)
                }
                Spacer()
            }
            .ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .fill(.clear)
                    .frame(height: UIScreen.main.bounds.height * 0.33)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            
                            HStack {
                                Text(recipe.title)
                                    .font(.inter(.interBold, size: 40))
                                    .lineLimit(2)
                                    .bold()
                                Spacer()
                                Text(recipe.cookingTime)
                                    .font(.inter(.interMedium, size: 30))

                            }
                            .foregroundStyle(.myBlack)

                            HStack {
                                VStack(alignment: .leading) {
                                    
                                    Text("Ingredients:")
                                        .font(.inter(.interBold, size: 24))
                                        .padding(.vertical)
                                    
                                    if recipe.ingredients.isEmpty {
                                        Text("Ingredients are not specified")
                                    }
                                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                                        Text("• \(ingredient)")
                                            .font(.inter(.interMedium, size: 20))
                                    }
                                    
                                    Text("Recipe:")
                                        .font(.inter(.interBold, size: 24))
                                        .padding(.vertical)

                                    Text(recipe.recipeText)
                                        .font(.inter(.interMedium, size: 20))
                                }
                                Spacer()
                            }
                            .foregroundStyle(.myBlack)
                        }
                    }
                    .padding(30)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.1) // 10% от высоты экрана
                }
                .frame(width: UIScreen.main.bounds.width ,height: UIScreen.main.bounds.height * 0.75)
                .background(Color.newWhite)
                .clipShape(RoundedRectangle(cornerRadius: 60))
                .ignoresSafeArea()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.newRed)
                        .font(.system(size: 20))
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
        }
    }
}
