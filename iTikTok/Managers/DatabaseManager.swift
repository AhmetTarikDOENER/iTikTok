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
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
