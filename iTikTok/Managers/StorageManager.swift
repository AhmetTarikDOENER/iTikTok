//
//  StorageManager.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    public static let shared = StorageManager()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    //MARK: - Public
    public func getVideoURL(
        with identifier: String,
        completion: (URL) -> Void
    ) {
        
    }
    
    public func uploadVideoURL(from URL: String) {
        
    }
}
