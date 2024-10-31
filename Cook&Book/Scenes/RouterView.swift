//
//  RouterView.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 23.10.2024.
//

import SwiftUI

struct RouterView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            switch appViewModel.status {
            case .login:
                LoginView()
            case .onboarding:
                EmptyView()
            case .main:
                MainView()
            }
        }
        .onAppear {
            print(appViewModel.status)
        }
    }
}

#Preview {
    RouterView()
}
