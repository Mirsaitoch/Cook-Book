//
//  ContentView.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            Color.newSkin.ignoresSafeArea()
            VStack {
                Spacer()
                recipes
                    .frame(height: UIScreen.main.bounds.height * 0.8)
            }
            header
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $viewModel.goToProfile) {
            ProfileView()
        }
        .sheet(isPresented: $viewModel.isShowPlusScreen) {
            AddRecipeView()
        }
        .onAppear {
            viewModel.fetchAllRecipes()
            viewModel.fetchPersonalRecipes()
        }
    }
    
    var header: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Spacer()
                    VStack {
                        Text("COOK & BOOK")
                            .font(.inter(.interBold, size: 38))
                            .foregroundStyle(.myBlack)
                        HStack {
                            Text("Explore recipes")
                                .foregroundStyle(viewModel.presentMode == .all ? .newRed : .black)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.presentMode = .all
                                    }
                                }
                            Text("|")
                                .bold()
                            Text("My recipes")
                                .foregroundStyle(viewModel.presentMode == .personal ? .newRed : .black)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.presentMode = .personal
                                        
                                    }
                                }
                        }
                        .font(.inter(.interBold, size: 19))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
            HStack {
                DropMenu {
                    viewModel.isShowPlusScreen.toggle()
                } profileAction: {
                    viewModel.goToProfile.toggle()
                }
                Spacer()
            }
            .padding(.top, 10)
            .padding(.horizontal)
        }
    }
    
    var recipes: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                if viewModel.presentMode == .all {
                    ForEach(viewModel.allRecipes, id: \.self) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            RecipeCell(recipe: recipe)
                        }
                    }
                } else {
                    ForEach(viewModel.personalRecipes, id: \.id) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            RecipeCell(recipe: recipe) {
                                viewModel.deleteRecipe(recipe)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    MainView()
}
