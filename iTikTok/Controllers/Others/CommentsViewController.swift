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
    
    weak var delegate: CommentsViewControllerDelegate?
    
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
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        view.backgroundColor = .systemPink
        fetchPostComments()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 60, y: 10, width: 35, height: 35)
    }
    
    //MARK: - Private
    private func fetchPostComments() {
        
    }
    
    @objc private func didTapCloseButton() {
        delegate?.didTapCloseForComments(with: self)
    }
}
