//
//  Notifications.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 5.02.2024.
//

import Foundation

enum NotificationType {
    case postLike(postName: String)
    case userFollow(username: String)
    case postComment(postName: String)
    
    var id: String {
        switch self {
        case .postLike:
            "postLike"
        case .userFollow:
            "userFollow"
        case .postComment:
            "postComment"
        }
    }
}

struct Notification {
    
    let text: String
    let type: NotificationType
    let date: Date
    
    static func mockData() -> [Notification] {
        Array(0...100).compactMap {
            Notification(
                text: "Something Happened: \($0)",
                type: .userFollow(username: "charliedamelio"),
                date: Date()
            )
        }
    }
}
