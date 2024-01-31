//
//  TabBarViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
    }
    
    //MARK: - Private
    private func setupControllers() {
        let homeVC = HomeViewController()
        let exploreVC = ExploreViewController()
        let cameraVC = CameraViewController()
        let notificationsVC = NotificationsViewController()
        let profileVC = ProfileViewController()
        
        homeVC.title = "Home"
        exploreVC.title = "Explore"
        notificationsVC.title = "Notifications"
        profileVC.title = "Profile"
        
        let navVC1 = UINavigationController(rootViewController: homeVC)
        let navVC2 = UINavigationController(rootViewController: exploreVC)
        let navVC3 = UINavigationController(rootViewController: notificationsVC)
        let navVC4 = UINavigationController(rootViewController: profileVC)
        
        navVC1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        navVC2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "safari"), tag: 2)
        cameraVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        navVC3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        navVC4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), tag: 5)
        
        setViewControllers([navVC1, navVC2, cameraVC, navVC3, navVC4], animated: false)
    }
}
