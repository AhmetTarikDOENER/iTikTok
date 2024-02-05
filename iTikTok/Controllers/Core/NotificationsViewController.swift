//
//  NotificationsViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    private var notifications = [Notification]()

    private let noNotificationsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "No Notifications"
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        
        return spinner
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView, noNotificationsLabel, spinnerView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationsLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noNotificationsLabel.center = view.center
        spinnerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinnerView.center = view.center
    }
    
    private func fetchNotifications() {
        DatabaseManager.shared.getNotifications {
            [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinnerView.stopAnimating()
                self?.spinnerView.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }
    
    private func updateUI() {
        if notifications.isEmpty {
            noNotificationsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNotificationsLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
