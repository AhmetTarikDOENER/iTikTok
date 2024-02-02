//
//  PostComment.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 3.02.2024.
//

import Foundation

struct PostComment {
    
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(username: "ahmettarik", profilePictureURL: nil, identifier: UUID().uuidString)
        
        var comments = [PostComment]()
        let text = [
            "This is cool",
            "This is not cool",
            "Is this what?"
        ]
        for comment in text {
            comments.append(
                PostComment(text: comment, user: user, date: Date())
            )
        }
        return comments
    }
}
