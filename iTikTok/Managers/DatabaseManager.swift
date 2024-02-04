//
//  DatabaseManager.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    public static let shared = DatabaseManager()
    private init() {}
    
    private let database = Database.database().reference()
    
    //MARK: - Public
    public func insertUser(
        with email: String,
        username: String,
        completion: @escaping (Bool) -> Void
    ) {
        // Get current users key
        // If exists new entry
        // Create root users
        database.child("users").observeSingleEvent(of: .value) {
            [weak self] snapshot in
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                // Create users root node
                
                self?.database.child("users").setValue(
                    [
                        username: [
                            "email": email
                        ]
                    ]) {
                        error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                return
            }
            usersDictionary[username] = ["email": email]
            // Save new users object
            self?.database.child("users").setValue(usersDictionary) {
                error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}

/*
 
    users: {
        "username": {
            email:
            posts: []
        }
    }
 
 */
