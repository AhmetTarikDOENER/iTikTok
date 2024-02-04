//
//  SignInViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit
import SafariServices

class SignInViewController: UIViewController {
    
    public var completion: (() -> Void)?
    
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    
    private let signInButton = AuthButton(type: .signIn, title: nil)
    private let signUpButton = AuthButton(type: .plain, title: "New User? Create Account")
    private let forgotPasswordButton = AuthButton(type: .plain, title: "Forgot Password")
    
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
        title = "Sign In"
        view.addSubviews(logoImageView, emailField, passwordField, signInButton, signUpButton, forgotPasswordButton)
        configureFields()
        configureButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
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
        emailField.frame = CGRect(
            x: 20,
            y: logoImageView.bottom + 20,
            width: view.width - 40,
            height: 55
        )
        passwordField.frame = CGRect(
            x: 20,
            y: emailField.bottom + 15,
            width: view.width - 40,
            height: 55
        )
        signInButton.frame = CGRect(
            x: 20,
            y: passwordField.bottom + 20,
            width: view.width - 40,
            height: 55
        )
        forgotPasswordButton.frame = CGRect(
            x: 20,
            y: signInButton.bottom + 40,
            width: view.width - 40,
            height: 55
        )
        signUpButton.frame = CGRect(
            x: 20,
            y: forgotPasswordButton.bottom + 20,
            width: view.width - 40,
            height: 55
        )
    }
    
    //MARK: - Private
    private func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        
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
    }
    
    private func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotButton), for: .touchUpInside)
    }
    
    @objc private func didTapKeyboardDone() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @objc private func didTapSignInButton() {
        didTapKeyboardDone()
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            let alert = UIAlertController(
                title: "Woops",
                message: "Please enter a valid email and password to sign in",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        AuthManager.shared.signIn(with: email, password: password) {
            [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let email):
                    self?.dismiss(animated: true)
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(
                        title: "Sign In Failed",
                        message: "Please check your email and password to try again",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self?.present(alert, animated: true)
                    self?.passwordField.text = nil
                }
            }
        }
        
    }
    
    @objc private func didTapSignUpButton() {
        didTapKeyboardDone()
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotButton() {
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/login/email/forget-password") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
