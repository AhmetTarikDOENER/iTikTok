//
//  Notifications.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 5.02.2024.
//

import Foundation

struct Notification {
    
    let text: String
    let date: Date
    
    static func mockData() -> [Notification] {
        Array(0...100).compactMap {
            Notification(text: "Something Happened: \($0)", date: Date())
        }
    }
}
