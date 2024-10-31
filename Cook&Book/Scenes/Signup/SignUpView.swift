//
//  SignUpView.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        ZStack {
            Image(.signupBg)
                .resizable()
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("Create account")
                        .multilineTextAlignment(.center)
                        .font(.inter(.interBlack, size: 40))
                        .foregroundStyle(.myBlack)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    VStack {
                        InputField(label: "Username", text: $viewModel.username)
                        InputField(label: "Email", text: $viewModel.email)
                        InputField(label: "Password", text: $viewModel.password, isSecure: true)
                        InputField(label: "Confirm password", text: $viewModel.confirmPass, isSecure: true)
                        
                        if !viewModel.errorText.isEmpty {
                            Text(viewModel.errorText)
                                .foregroundStyle(.red)
                                .font(.inter(.interMedium))
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    PinkButton(text: "Sign up") {
                        Task {
                            do {
                                await viewModel.register()
                                if viewModel.errorText.isEmpty {
                                    appViewModel.changeIsLogin(true)
                                    appViewModel.status = .main
                                    dismiss()
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 40)
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SignupView()
}
