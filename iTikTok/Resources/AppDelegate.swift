//
//  AppDelegate.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = TabBarViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        FirebaseApp.configure()
        
//        AuthManager.shared.signOut {
//            _ in
//            
//        }
        
        return true
    }
}

