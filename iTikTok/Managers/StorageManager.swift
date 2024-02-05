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
    
    private let storageBucket = Storage.storage().reference()
    
    //MARK: - Public
    public func getVideoURL(
        with identifier: String,
        completion: (URL) -> Void
    ) {
        
    }
    
    public func uploadVideo(
        from url: URL,
        filename: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        storageBucket.child("videos/\(username)/\(filename)").putFile(
            from: url,
            metadata: nil) {
                _, error in
                completion(error == nil)
            }
    }
    
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamps = Date().timeIntervalSince1970
        
        return uuidString + "_\(number)_" + "\(unixTimestamps)" + ".mov"
    }
}
