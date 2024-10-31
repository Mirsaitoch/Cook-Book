//
//  AddRecipeView.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 21.10.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import PhotosUI

struct AddRecipeView: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.newSkin.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack {
                    VStack {
                        HStack {
                            TextField("Title", text: $viewModel.title, prompt: Text("Title").foregroundColor(.gray.opacity(0.4)))
                                .font(.inter(.interBold, size: 40))
                                .foregroundColor(.myBlack)
                                .padding()
                            
                            if let image = viewModel.recipeImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                            } else {
                                Button(action: {
                                    viewModel.showImagePicker = true
                                }) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.myBlack)
                                        .padding()
                                }
                            }
                        }
                        HStack {
                            Text("This is a required field")
                                .font(.inter(.interBold, size: 14))
                                .foregroundStyle(.red)
                                .opacity(viewModel.tryedToSaveRecipe && viewModel.description.isEmpty ? 1.0 : 0.0)
                                .padding(.top, -25)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    VStack {
                        HStack {
                            Text("Description")
                                .font(.inter(.interBold, size: 19))
                                .foregroundStyle(.myBlack)
                            Text("This is a required field")
                                .font(.inter(.interBold, size: 14))
                                .foregroundStyle(.red)
                                .opacity(viewModel.tryedToSaveRecipe && viewModel.description.isEmpty ? 1.0 : 0.0)
                            Spacer()
                        }
                        
                        ZStack(alignment: .topLeading) {
                            if viewModel.description.isEmpty {
                                Text("Enter your text here...")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 6)
                                    .padding(.top, 10)
                                    .font(.inter(.interBold, size: 19))
                                
                            }
                            
                            TextEditor(text: $viewModel.description)
                                .scrollContentBackground(.hidden)
                                .font(.inter(.interBold, size: 19))
                                .foregroundStyle(.myBlack)
                                .background(.clear)
                                .frame(height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(4)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            Text("Cooking time")
                                .font(.inter(.interBold, size: 19))
                                .foregroundStyle(.myBlack)
                            Spacer()
                        }
                        
                        HStack {
                            Picker("Hours", selection: $viewModel.cookingTimeHours) {
                                ForEach(0..<24) { Text("\($0) h").foregroundColor(.myBlack) }
                            }
                            Picker("Minutes", selection: $viewModel.cookingTimeMinutes) {
                                ForEach(0..<60) { Text("\($0) min").foregroundColor(.myBlack) }
                            }
                        }
                        .frame(height: 70)
                        .padding()
                        .pickerStyle(.wheel)

                    }
                    .padding(.horizontal)
                    
                    Menu {
                        ForEach(viewModel.ingredients, id: \.self) { ingredient in
                            Button(action: {
                                if !viewModel.selectedIngredients.contains(ingredient) {
                                    viewModel.selectedIngredients.append(ingredient)
                                }
                            }) {
                                Text(ingredient)
                            }
                        }
                    } label: {
                        HStack {
                            Label("Add Ingredients", systemImage: "plus.circle")
                                .foregroundStyle(.myBlack)
                                .font(.inter(.interBold, size: 19))
                            Spacer()
                        }
                    }
                    
                    List(viewModel.selectedIngredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .foregroundColor(.myBlack)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.inset)
                    .frame(height: 150)
                    .border(.myBlack.opacity(0.4))
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    
                    
                    VStack {
                        HStack {
                            Text("Recipe")
                                .font(.inter(.interBold, size: 19))
                                .foregroundStyle(.myBlack)
                            Text("This is a required field")
                                .font(.inter(.interBold, size: 14))
                                .foregroundStyle(.red)
                                .opacity(viewModel.tryedToSaveRecipe && viewModel.recipeText.isEmpty ? 1.0 : 0.0)
                            Spacer()
                        }
                        
                        ZStack(alignment: .topLeading) {
                            if viewModel.recipeText.isEmpty {
                                Text("Enter your text here...")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 6)
                                    .padding(.top, 10)
                                    .font(.inter(.interBold, size: 19))
                                
                            }
                            
                            TextEditor(text: $viewModel.recipeText)
                                .scrollContentBackground(.hidden)
                                .font(.inter(.interBold, size: 19))
                                .foregroundStyle(.myBlack)
                                .background(.clear)
                                .frame(height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(4)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    
                    PinkButton(text: "Save Recipe") {
                        viewModel.saveRecipe()
                        if !viewModel.tryedToSaveRecipe {
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        
        .sheet(isPresented: $viewModel.showImagePicker) {
            PHPickerViewController.View(image: $viewModel.recipeImage)
        }
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


#Preview {
    AddRecipeView()
}
