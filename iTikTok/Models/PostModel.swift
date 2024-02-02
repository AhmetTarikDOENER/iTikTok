//
//  PostModel.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 1.02.2024.
//

import Foundation

struct PostModel {
    
    let identifier: String
    var isLikedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        let posts = Array(0...100).compactMap {
            _ in
            PostModel(identifier: UUID().uuidString)
        }
        return posts
    }
}
