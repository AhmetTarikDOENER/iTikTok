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
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc private func didTapPostButton() {
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
                        DatabaseManager.shared.insertPost(with: newVideoName) { databaseUpdated in
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
