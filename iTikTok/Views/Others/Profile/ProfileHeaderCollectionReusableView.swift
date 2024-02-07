//
//  ProfileHeaderCollectionReusableView.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 6.02.2024.
//

import UIKit
import SDWebImage

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableView(
        _ header: ProfileHeaderCollectionReusableView,
        didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel
    )
    func profileHeaderCollectionReusableView(
        _ header: ProfileHeaderCollectionReusableView,
        didTapFollowersButtonWith viewModel: ProfileHeaderViewModel
    )
    func profileHeaderCollectionReusableView(
        _ header: ProfileHeaderCollectionReusableView,
        didTapFollowingButtonWith viewModel: ProfileHeaderViewModel
    )
    func profileHeaderCollectionReusableView(
        _ header: ProfileHeaderCollectionReusableView,
        didTapAvatarFor viewModel: ProfileHeaderViewModel
    )
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    var viewModel: ProfileHeaderViewModel?
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        
        return imageView
    }()
    
    private let primaryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("0\nFollow", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
        
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("0\nFollowers", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
        
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("0\nFollowing", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
        
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        addSubviews(avatarImageView, primaryButton, followersButton, followingButton)
        configureButtons()
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let avatarSize: CGFloat = 130
        avatarImageView.frame = CGRect(
            x: (self.width - avatarSize) / 2,
            y: 5,
            width: avatarSize,
            height: avatarSize
        )
        avatarImageView.layer.cornerRadius = avatarImageView.height / 2
        
        let buttonFullWidth: CGFloat = 210
        followersButton.frame = CGRect(
            x: (self.width - buttonFullWidth) / 2,
            y: avatarImageView.bottom + 10,
            width: 100,
            height: 44
        )
        followingButton.frame = CGRect(
            x: followersButton.right + 10,
            y: avatarImageView.bottom + 10,
            width: 100,
            height: 44
        )
        primaryButton.frame = CGRect(
            x: (self.width - 220) / 2,
            y: followingButton.bottom + 15,
            width: 220,
            height: 44
        )
    }
    
    //MARK: - Private
    @objc private func didTapAvatar() {
        guard let viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self, didTapAvatarFor: viewModel)
    }
    
    private func configureButtons() {
        primaryButton.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
    }
    
    @objc private func didTapPrimaryButton() {
        guard let viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self, didTapPrimaryButtonWith: viewModel)
    }
    
    @objc private func didTapFollowersButton() {
        guard let viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowersButtonWith: viewModel)
    }
    
    @objc private func didTapFollowingButton() {
        guard let viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowingButtonWith: viewModel)
    }
    
    func configure(with viewModel: ProfileHeaderViewModel) {
        self.viewModel = viewModel
        followersButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)
        if let avatarURL = viewModel.avatarImageURL {
            avatarImageView.sd_setImage(with: avatarURL)
        } else {
            avatarImageView.image = UIImage(named: "test")
        }
        if let isFollowing = viewModel.isFollowing {
            primaryButton.backgroundColor = isFollowing ? .secondarySystemBackground : .systemPink
            primaryButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
        } else {
            primaryButton.backgroundColor = .secondarySystemBackground
            primaryButton.setTitle("Edit Profile", for: .normal)
        }
    }
    
}
