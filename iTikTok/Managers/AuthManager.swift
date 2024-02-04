//
//  AuthManager.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    public static let shared = AuthManager()
    private init() {}
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    //MARK: - Public
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
}
