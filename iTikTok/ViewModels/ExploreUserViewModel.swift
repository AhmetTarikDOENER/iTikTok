//
//  ExploreUserViewModel.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 3.02.2024.
//

import UIKit

struct ExploreUserViewModel {
    
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
