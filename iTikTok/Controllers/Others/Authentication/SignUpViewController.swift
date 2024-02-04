//
//  SignUpViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController {

    public var completion: (() -> Void)?
    
    private let emailField = AuthField(type: .email)
    private let usernameField = AuthField(type: .username)
    private let passwordField = AuthField(type: .password)
    
    private let signUpButton = AuthButton(type: .signUp, title: "New User? Create Account")
    private let termsButton = AuthButton(type: .plain, title: "Terms of Service")
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "logo")
        
        return imageView
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Create Account"
        view.addSubviews(logoImageView, emailField, passwordField, usernameField, signUpButton, termsButton)
        configureFields()
        configureButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageSize: CGFloat = 100
        logoImageView.frame = CGRect(
            x: (view.width - imageSize) / 2,
            y: view.safeAreaInsets.top + 5,
            width: imageSize,
            height: imageSize
        )
        usernameField.frame = CGRect(
            x: 20,
            y: logoImageView.bottom + 20,
            width: view.width - 40,
            height: 55
        )
        emailField.frame = CGRect(
            x: 20,
            y: usernameField.bottom + 15,
            width: view.width - 40,
            height: 55
        )
        passwordField.frame = CGRect(
            x: 20,
            y: emailField.bottom + 20,
            width: view.width - 40,
            height: 55
        )
        signUpButton.frame = CGRect(
            x: 20,
            y: passwordField.bottom + 20,
            width: view.width - 40,
            height: 55
        )
        termsButton.frame = CGRect(
            x: 20,
            y: signUpButton.bottom + 20,
            width: view.width - 40,
            height: 55
        )
    }
    
    //MARK: - Private
    private func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        usernameField.delegate = self
        
        let toolBar = UIToolbar(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: 50
            )
        )
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        emailField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
        usernameField.inputAccessoryView = toolBar
    }
    
    private func configureButtons() {
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
    }
    
    @objc private func didTapKeyboardDone() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
    }

    @objc private func didTapSignUpButton() {
        didTapKeyboardDone()
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.contains(" "),
              !username.contains("."),
              password.count >= 6 else {
            let alert = UIAlertController(
                title: "Woops",
                message: "Please make sure to enter a valid usrename, email and password. Your password must be at least 6 characters long",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        AuthManager.shared.signUp(
            with: username,
            emailAddress: email,
            password: password) {
                [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        self?.dismiss(animated: true)
                    } else {
                        let alert = UIAlertController(
                            title: "Sign Up Failed",
                            message: "Something went wrong when trying to register. Please try again.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        self?.present(alert, animated: true)
                    }
                }
            }
    }
    
    @objc private func didTapTermsButton() {
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/legal/page/row/terms-of-service/tr") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameField:
            emailField.becomeFirstResponder()
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            signUpButton.resignFirstResponder()
        default:
            resignFirstResponder()
        }
        return true
    }
}
