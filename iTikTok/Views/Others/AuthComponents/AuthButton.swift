//
//  AuthButton.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 4.02.2024.
//

import UIKit

class AuthButton: UIButton {
    
    enum ButtonType {
        case signIn
        case signUp
        case plain
        
        var title: String {
            switch self {
            case .signIn:
                "Sign In"
            case .signUp:
                "Sign Up"
            case .plain:
                "-"
            }
        }
    }
    
    private let type: ButtonType
    
    init(type: ButtonType, title: String?) {
        self.type = type
        super.init(frame: .zero)
        if let title = title {
            setTitle(title, for: .normal)
        }
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        if type != .plain {
            setTitle(type.title, for: .normal)
        }
        switch type {
        case .signIn:
            backgroundColor = .systemBlue
        case .signUp:
            backgroundColor = .systemGreen
        case .plain:
            setTitleColor(.link, for: .normal)
            backgroundColor = .clear
        }
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
