//
//  AuthField.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 4.02.2024.
//

import UIKit

class AuthField: UITextField {
    
    private let type: FieldType
    
    enum FieldType {
        case email
        case password
        case username
        
        var title: String {
            switch self {
            case .email:
                "Email Address"
            case .password:
                "Password"
            case .username:
                "Username"
            }
        }
    }
    
    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        autocapitalizationType = .none
        if type == .password { isSecureTextEntry = true }
        else if type == .email { keyboardType = .emailAddress }
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        autocorrectionType = .no
    }
    
}
