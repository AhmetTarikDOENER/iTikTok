//
//  CommentViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 2.02.2024.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}

class CommentsViewController: UIViewController {

    private let post: PostModel
    private var comments = [PostComment]()
    
    weak var delegate: CommentsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        return table
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    //MARK: - Init
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(closeButton, tableView)
        tableView.delegate = self
        tableView.dataSource = self
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        view.backgroundColor = .systemBackground
        fetchPostComments()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 60, y: 10, width: 35, height: 35)
        tableView.frame = CGRect(x: 0, y: closeButton.bottom, width: view.width, height: view.height - closeButton.bottom)
    }
    
    //MARK: - Private
    private func fetchPostComments() {
        self.comments = PostComment.mockComments()
    }
    
    @objc private func didTapCloseButton() {
        delegate?.didTapCloseForComments(with: self)
    }
}
extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
