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
        tableView.register(
            NotificationsUserFollowTableViewCell.self,
            forCellReuseIdentifier: NotificationsUserFollowTableViewCell.identifier
        )
        tableView.register(
            NotificationsPostCommentTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostCommentTableViewCell.identifier
        )
        tableView.register(
            NotificationsPostLikeTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostLikeTableViewCell.identifier
        )
        
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
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = control
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
    
    //MARK: - Private
    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        DatabaseManager.shared.getNotifications {
            [weak self] notifications in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.notifications = notifications
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
        }
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
        switch model.type {
        case .postLike(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsPostLikeTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsPostLikeTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
            
        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsUserFollowTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsUserFollowTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(with: username, model: model)
            return cell
            
        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsPostCommentTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsPostCommentTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        let model = notifications[indexPath.row]
        model.isHidden = true
        
        DatabaseManager.shared.markNotificationAsHidden(
            notificationID: model.identifier) {
                [weak self] success in
                if success {
                    self?.notifications = self?.notifications.filter { $0.isHidden == false } ?? []
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension NotificationsViewController: NotificationsUserFollowTableViewCellDelegate {
    
    func notificationsUserFollowTableViewCell(
        _ cell: NotificationsUserFollowTableViewCell,
        didTapAvatarFor username: String
    ) {
        HapticsManager.shared.vibrateForSelection()
        let vc = ProfileViewController(
            user: User(
                username: username,
                profilePictureURL: nil,
                identifier: "123"
            )
        )
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func notificationsUserFollowTableViewCell(
        _ cell: NotificationsUserFollowTableViewCell,
        didTapFollowFor username: String
    ) {
        DatabaseManager.shared.udpateRelationship(
            for: User(
                username: username,
                profilePictureURL: nil,
                identifier: UUID().uuidString
            ),
            follow: true) {
                success in
                if !success {
                    // Something went wrong
                }
            }
    }
}

extension NotificationsViewController {
    func openPost(with identifier: String) {
        HapticsManager.shared.vibrateForSelection()
        // Resolve the post model from database
        let vc = PostViewController(
            model: PostModel(
                identifier: identifier,
                user: User(
                    username: "ahmez",
                    profilePictureURL: nil,
                    identifier: UUID().uuidString
                )
            )
        )
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotificationsViewController: NotificationsPostLikeTableViewCellDelegate {
    func notificationsPostLikeTableViewCell(
        _ cell: NotificationsPostLikeTableViewCell,
        didTapPostWith identifier: String
    ) {
        openPost(with: identifier)
    }
}

extension NotificationsViewController: NotificationsPostCommentTableViewCellDelegate {
    func notificationsPostCommentTableViewCell(
        _ cell: NotificationsPostCommentTableViewCell,
        didTapPostWith identifier: String
    ) {
        openPost(with: identifier)
    }
}
