//
//  CaptionViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 5.02.2024.
//

import UIKit
import JGProgressHUD

class CaptionViewController: UIViewController {

    private let videoURL: URL
    private let progressHUD = JGProgressHUD()
    
    private let captionTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        
        return textView
    }()
    
    //MARK: - Init
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(didTapPostButton)
        )
        view.addSubviews(captionTextView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.frame = CGRect(
            x: 5,
            y: view.safeAreaInsets.top + 5,
            width: view.width - 10,
            height: 150
        ).integral
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
    
    //MARK: - Private
    @objc private func didTapPostButton() {
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
        // Generate a video name that is unique based on id
        let newVideoName = StorageManager.shared.generateVideoName()
        progressHUD.show(in: self.view)
        // Upload video
        StorageManager.shared.uploadVideo(
            from: videoURL,
            filename: newVideoName) {
                [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        // Update database
                        DatabaseManager.shared.insertPost(
                            with: newVideoName,
                            caption: caption
                        ) { databaseUpdated in
                            if databaseUpdated {
                                HapticsManager.shared.vibrate(for: .success)
                                self?.progressHUD.dismiss()
                                // Reset camera and switch to feed
                                self?.navigationController?.popViewController(animated: true)
                                self?.tabBarController?.selectedIndex = 0
                                self?.tabBarController?.tabBar.isHidden = false
                            } else {
                                HapticsManager.shared.vibrate(for: .error)
                                self?.progressHUD.dismiss()
                                let alert = UIAlertController(
                                    title: "Woops",
                                    message: "We were unable to upload your video. Please try again.",
                                    preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                                self?.present(alert, animated: true)
                            }
                        }
                    } else {
                        HapticsManager.shared.vibrate(for: .error)
                        self?.progressHUD.dismiss()
                        let alert = UIAlertController(
                            title: "Woops",
                            message: "We were unable to upload your video. Please try again.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        self?.present(alert, animated: true)
                    }
                }
            }
    }
}
