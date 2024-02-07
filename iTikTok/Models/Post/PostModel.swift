//
//  PostModel.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 1.02.2024.
//

import Foundation

struct PostModel {
    
    let identifier: String
    let user: User
    var fileName: String = ""
    var caption: String = ""
    var isLikedByCurrentUser = false
    
    var videoChildPath: String {
        "videos/\(user.username.lowercased())/\(fileName)"
    }
    
    static func mockModels() -> [PostModel] {
        let posts = Array(0...100).compactMap {
            _ in
            PostModel(
                identifier: UUID().uuidString,
                user: User(
                    username: "ahmet",
                    profilePictureURL: nil,
                    identifier: UUID().uuidString
                )
            )
        }
        return posts
    }
}
