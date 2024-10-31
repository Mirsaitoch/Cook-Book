//
//  Cook_BookApp.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
#if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
#endif
        FirebaseApp.configure()

        return true
    }
}

@main
struct Cook_BookApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isLoggedIn") var isLogin = false
    @ObservedObject var appViewModel = AppViewModel()
    
    init() {
        if isLogin {
            appViewModel.status = .main
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RouterView()
                .environmentObject(appViewModel)
        }
    }
}

