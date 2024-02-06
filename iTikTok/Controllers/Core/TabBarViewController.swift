//
//  TabBarViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var signInPresented = false

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
        }
    }
    
    //MARK: - Private
    private func presentSignInIfNeeded() {
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = SignInViewController()
            vc.completion = {
                [weak self] in
                self?.signInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: false)
        }
    }
    
    private func setupControllers() {
        let homeVC = HomeViewController()
        let exploreVC = ExploreViewController()
        let cameraVC = CameraViewController()
        let notificationsVC = NotificationsViewController()
        
        var urlString: String?
        if let cachedUrlString = UserDefaults.standard.string(forKey: "profile_pictures") {
            urlString = cachedUrlString
        }
        let profileVC = ProfileViewController(
            user: User(
                username: UserDefaults.standard.string(forKey: "username")?.uppercased() ?? "MyProfile",
                profilePictureURL: URL(string: urlString ?? ""),
                identifier: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
            )
        )
        
        notificationsVC.title = "Notifications"
        profileVC.title = "Profile"
        
        let navVC1 = UINavigationController(rootViewController: homeVC)
        let navVC2 = UINavigationController(rootViewController: exploreVC)
        let cameraNav = UINavigationController(rootViewController: cameraVC)
        let navVC3 = UINavigationController(rootViewController: notificationsVC)
        let navVC4 = UINavigationController(rootViewController: profileVC)
        
        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        cameraNav.navigationBar.tintColor = .white
        
        navVC3.navigationBar.tintColor = .label
    
        navVC1.navigationBar.backgroundColor = .clear
        navVC1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC1.navigationBar.shadowImage = UIImage()
        
        navVC1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        navVC2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "safari"), tag: 2)
        cameraVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        navVC3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        navVC4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), tag: 5)
        
        if #available(iOS 14.0, *) {
            navVC1.navigationItem.backButtonDisplayMode = .minimal
            navVC2.navigationItem.backButtonDisplayMode = .minimal
            navVC3.navigationItem.backButtonDisplayMode = .minimal
            navVC4.navigationItem.backButtonDisplayMode = .minimal
            cameraVC.navigationItem.backButtonDisplayMode = .minimal
        }
        
        setViewControllers([navVC1, navVC2, cameraNav, navVC3, navVC4], animated: false)
    }
}
