//
//  AppViewModel.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var status: ScreenTrace = .login
    @AppStorage("isLoggedIn") var isLogin = false
    
    func changeIsLogin(_ value: Bool) {
        isLogin = value
    }
}
