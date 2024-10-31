//
//  LoginView.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @AppStorage("isLoggedIn") var isLogin = false
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = LogInModel()
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        content
    }
    
    var content: some View {
        
        ZStack {
            Image(.loginBg)
                .resizable()
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("COOK\n&\nBOOK")
                    .multilineTextAlignment(.center)
                    .font(.inter(.interBlack, size: 55))
                    .foregroundStyle(.myBlack)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    InputField(label: "Email", text: $viewModel.email)
                    
                    InputField(label: "Password", text: $viewModel.password, isSecure: true)
                    
                    HStack {
                        Text(viewModel.errorText)
                            .foregroundStyle(.red)
                            .font(.inter(.interBold))
                            .lineLimit(0)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                PinkButton(text: "Login") {
                    Task {
                        do {
                            try await viewModel.signIn()
                            isLogin = true
                            appViewModel.status = .main
                        } catch {
                            viewModel.errorText = error.localizedDescription
                        }
                    }
                }
                
                Spacer()
                
                NavigationLink {
                    SignupView()
                } label: {
                    HStack {
                        Text("Don’t have an account?")
                            .foregroundStyle(.newPink)
                        Text("Sign up")
                            .foregroundStyle(.newWhite)
                    }
                    .font(.inter(.interBold, size: 18))
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onSubmit {
            if focusedField == .username {
                focusedField = .password
            } else {
                focusedField = nil
            }
        }
    }
}

#Preview {
    LoginView()
}
