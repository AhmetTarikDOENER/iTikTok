//
//  ProfileViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
}
