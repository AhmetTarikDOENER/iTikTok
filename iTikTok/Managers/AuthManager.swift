//
//  AuthManager.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import Foundation
import FirebaseAuth

/// Manager responsible for sign-in, sing-up or sign-out
final class AuthManager {
    
    /// Singleton shared instances of the manager
    public static let shared = AuthManager()
    private init() {}
    /// Represents sign-in methods
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    /// Represents errors that can occur in authentication flows
    enum AuthError: Error {
        case signInFailed
    }
    //MARK: - Public
    /// Represent if user is signed-in
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    /// Attempt to sign-in
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Async result callback
    public func signIn(
        with email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, error in
            guard result != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }
            DatabaseManager.shared.getUsername(for: email) {
                username in
                if let username = username {
                    UserDefaults.standard.set(username, forKey: "username")
                    print("Got username: \(username)")
                }
            }
            // Succesfull Sign In
            completion(.success(email))
        }
    }
    /// Attempt to sign-up
    /// - Parameters:
    ///   - username: Desired user name
    ///   - emailAddress: User email
    ///   - password: User password
    ///   - completion: Async result callback
    public func signUp(
        with username: String,
        emailAddress: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) {
        // Make sure entered username is available
        Auth.auth().createUser(withEmail: emailAddress, password: password) {
            result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            UserDefaults.standard.set(username, forKey: "username")
            DatabaseManager.shared.insertUser(
                with: emailAddress,
                username: username,
                completion: completion
            )
        }
    }
    
    /// Attempt to sign-out
    /// - Parameter completion: Async callback of sign-out result
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
}
