//
//  CommentViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 2.02.2024.
//

import UIKit

class CommentViewController: UIViewController {

    private let post: PostModel
    
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
        view.backgroundColor = .systemPink
        fetchPostComments()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func fetchPostComments() {
        
    }
}
