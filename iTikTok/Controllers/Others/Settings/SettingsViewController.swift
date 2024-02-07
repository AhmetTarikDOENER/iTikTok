//
//  SettingsViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit

class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        createFooterView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func createFooterView() {
        let footerView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: 100
            )
        )
        let button = UIButton(
            frame: CGRect(
                x: (view.width - 200) / 2,
                y: 25,
                width: 200,
                height: 50
            )
        )
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        footerView.addSubview(button)
        tableView.tableFooterView = footerView
    }
    
    @objc private func didTapSignOut() {
        let actionSheet = UIAlertController(
            title: "Sign Out",
            message: "Would you like to sign out?",
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )
        actionSheet.addAction(
            UIAlertAction(
                title: "Sign Out",
                style: .destructive,
                handler: {
                    [weak self] _ in
                    DispatchQueue.main.async {
                        AuthManager.shared.signOut {
                            success in
                            if success {
                                UserDefaults.standard.set(nil, forKey: "username")
                                UserDefaults.standard.set(nil, forKey: "profile_picture")
                                let vc = SignInViewController()
                                let navVC = UINavigationController(rootViewController: vc)
                                navVC.modalPresentationStyle = .fullScreen
                                self?.present(navVC, animated: true)
                                self?.navigationController?.popToRootViewController(animated: true)
                                self?.tabBarController?.selectedIndex = 0
                            } else {
                                let alert = UIAlertController(
                                    title: "Woops",
                                    message: "Something went wrong when signin out. Please try again",
                                    preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                                self?.present(alert, animated: true)
                            }
                        }
                    }
                }
            )
        )
        present(actionSheet, animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello"
        
        return cell
    }
}
