//
//  StorageManager.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit
import FirebaseStorage

/// Manager object that deals with firebase storage
final class StorageManager {
    
    /// Shared singleton instance
    public static let shared = StorageManager()
    /// Privatized initializer
    private init() {}
    
    /// Storage bucket reference
    private let storageBucket = Storage.storage().reference()
    
    //MARK: - Public
    
    /// Upload a new user video to firebase
    /// - Parameters:
    ///   - url: Local file URL to the video
    ///   - filename: Desired video file upload name
    ///   - completion: Async callback result closure
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
    
    /// Upload new profile picture
    /// - Parameters:
    ///   - image: New image to upload
    ///   - completion: Async callback to result
    public func uploadProfilePicture(
        with image: UIImage,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        guard let imageData = image.pngData() else { return }
        let path = "profile_pictures/\(username)/picture.png"
        storageBucket.child(path).putData(
            imageData,
            metadata: nil
        ) {
            _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.storageBucket.child(path).downloadURL {
                    url, error in
                    guard let url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    completion(.success(url))
                }
            }
        }
    }
    /// Generates a new file name
    /// - Returns: Unique generated file name
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamps = Date().timeIntervalSince1970
        
        return uuidString + "_\(number)_" + "\(unixTimestamps)" + ".mov"
    }
    /// Get downloaded URL of video post
    /// - Parameters:
    ///   - post: Post model to get URL for
    ///   - completion: Async callback
    func getDownloadURL(
        for post: PostModel,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        storageBucket.child(post.videoChildPath).downloadURL {
            url, error in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            }
        }
    }
}
