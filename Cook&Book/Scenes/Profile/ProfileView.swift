//
//  ProfileView.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") var isLogin = false
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ZStack {
            Image(.profileBg)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            ScrollView(showsIndicators: false) {
                VStack {
                    if viewModel.isEditing {
                        Group {
                            Spacer()
                            
                            if let image = viewModel.profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        viewModel.showImagePicker = true
                                    }
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 200, height: 200)
                                    .overlay {
                                        Image(systemName: "person")
                                            .font(.system(size: 72))
                                    }
                                    .onTapGesture {
                                        viewModel.showImagePicker = true
                                    }
                            }
                            
                            InputField(label: "Username", text: $viewModel.username)
                            
                            VStack {
                                HStack {
                                    Text("About me")
                                        .font(.inter(.interBold, size: 19))
                                    Spacer()
                                }
                                TextEditor(text: $viewModel.aboutText)
                                    .scrollContentBackground(.hidden)
                                    .background(.myWhite)
                                    .frame(height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            }
                            .padding(.horizontal)
                            
                            Spacer()
                            
                            PinkButton(text: "Save") {
                                Task {
                                    viewModel.isSaving = true
                                    await viewModel.saveUserData()
                                    await viewModel.uploadProfileImage(image: viewModel.profileImage)
                                    viewModel.isEditing.toggle()
                                    viewModel.isSaving = false
                                }
                            }
                            
                            PinkButton(text: "Delete account") {
                                viewModel.showPasswordAlert = true
                            }
                            
                            Spacer()
                        }
                        .disabled(viewModel.isSaving)
                        
                    } else {
                        Spacer()
                        
                        if let image = viewModel.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 200, height: 200)
                                .overlay {
                                    Image(systemName: "person")
                                        .font(.system(size: 72))
                                }
                        }
                        
                        Text(viewModel.username)
                            .foregroundStyle(.black)
                            .font(.inter(.interBold, size: 36))
                            .multilineTextAlignment(.center)
                        HStack {
                            Text("About me")
                                .foregroundStyle(.newRed)
                                .font(.inter(.interBold, size: 22))
                            Spacer()
                        }
                        .padding(.horizontal)
                        HStack {
                            Text(viewModel.aboutText.isEmpty ? "No information yet" : viewModel.aboutText)
                                .font(.inter(.interMedium, size: 18))
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        Spacer()
                        PinkButton(text: "Edit profile") {
                            viewModel.isEditing.toggle()
                        }
                        Spacer()
                    }
                }
                .overlay {
                    if viewModel.isSaving {
                        ProgressView()
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.newRed)
                    .font(.system(size: 20))
                    .onTapGesture {
                        dismiss()
                    }
                    .disabled(viewModel.isSaving)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "door.left.hand.open")
                    .foregroundColor(.newRed)
                    .font(.system(size: 20))
                    .onTapGesture {
                        Task {
                            do {
                                try viewModel.logOut()
                                isLogin = false
                                appViewModel.status = .login
                                dismiss()
                            }
                            catch {
                                print("error logOut")
                            }
                        }
                    }
                    .disabled(viewModel.isSaving)
            }
        }
        .onAppear {
            Task {
                do {
                    await viewModel.fetchUserData()
                    await viewModel.fetchProfileImage()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $viewModel.showImagePicker) {
            PHPickerViewController.View(image: $viewModel.profileImage)
        }
        .alert("Enter Password", isPresented: $viewModel.showPasswordAlert) {
            SecureField("Password", text: $viewModel.password)
            Button("Delete", action: {
                Task {
                    do {
                        try await viewModel.reauthenticateAndDeleteAccount(password: viewModel.password) { result in
                            switch result {
                            case .success:
                                isLogin = false
                                appViewModel.status = .login
                                dismiss()
                                print("Account deleted successfully")
                            case .failure(let error):
                                viewModel.errorMessage = error.localizedDescription
                                viewModel.showPasswordAlert = true
                            }
                        }
                    } catch {
                        viewModel.errorMessage = error.localizedDescription
                        viewModel.showPasswordAlert = true
                    }
                }
            })
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    ProfileView()
}
