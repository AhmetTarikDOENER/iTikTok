//
//  NotificationsUserFollowTableViewCell.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 5.02.2024.
//

import UIKit

protocol NotificationsUserFollowTableViewCellDelegate: AnyObject {
    func notificationsUserFollowTableViewCell(
        _ cell: NotificationsUserFollowTableViewCell,
        didTapFollowFor username: String
    )
    func notificationsUserFollowTableViewCell(
        _ cell: NotificationsUserFollowTableViewCell,
        didTapAvatarFor username: String
    )
}

class NotificationsUserFollowTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationsUserFollowTableViewCell"
    
    weak var delegate: NotificationsUserFollowTableViewCellDelegate?
    
    var username: String?
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
//        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        
        return button
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubviews(avatarImageView, label, dateLabel, followButton)
        selectionStyle = .none
        followButton.addTarget(self, action: #selector(didTapFollowButton(_:)), for: .touchUpInside)
        
        avatarImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAvatarImageView))
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconSize: CGFloat = 50
        avatarImageView.frame = CGRect(
            x: 10,
            y: 3,
            width: iconSize,
            height: iconSize
        )
        avatarImageView.layer.cornerRadius = iconSize / 2
        
        followButton.sizeToFit()
        followButton.frame = CGRect(
            x: contentView.width - 110,
            y: 10,
            width: 100,
            height: 30
        )
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        let labelSize = label.sizeThatFits(
            CGSize(
                width: contentView.width - 30 - followButton.width - iconSize,
                height: contentView.height - 40
            )
        )
        
        label.frame = CGRect(
            x: avatarImageView.right + 10,
            y: 0,
            width: labelSize.width,
            height: labelSize.height
        )
        
        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: label.bottom + 3,
            width: contentView.width - avatarImageView.width - followButton.width,
            height: 40
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    //MARK: - Private
    @objc private func didTapAvatarImageView() {
        guard let username else { return }
        delegate?.notificationsUserFollowTableViewCell(self, didTapAvatarFor: username)
    }
    
    @objc private func didTapFollowButton(_ sender: UIButton) {
        guard let username else { return }
        delegate?.notificationsUserFollowTableViewCell(self, didTapFollowFor: username)
    }
    
    func configure(with username: String, model: Notification) {
        avatarImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
        self.username = username
    }
    
}
