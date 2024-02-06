//
//  NotificationsPostLikeTableViewCellTableViewCell.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 5.02.2024.
//

import UIKit

protocol NotificationsPostLikeTableViewCellDelegate: AnyObject {
    func notificationsPostLikeTableViewCell(
        _ cell: NotificationsPostLikeTableViewCell,
        didTapPostWith identifier: String
    )
}

class NotificationsPostLikeTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationsPostLikeTableViewCell"
    
    weak var delegate: NotificationsPostLikeTableViewCellDelegate?
    
    var postID: String?
    
    private let postThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
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

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubviews(postThumbnailImageView, label, dateLabel)
        selectionStyle = .none
        postThumbnailImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postThumbnailImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        postThumbnailImageView.frame = CGRect(
            x: contentView.width - 50,
            y: 3,
            width: 50,
            height: contentView.height - 6
        )
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        let labelSize = label.sizeThatFits(
            CGSize(
                width: contentView.width - 10 - postThumbnailImageView.width - 5,
                height: contentView.height - 40
            )
        )
        
        label.frame = CGRect(
            x: 10,
            y: 0,
            width: labelSize.width,
            height: labelSize.height
        )
        
        dateLabel.frame = CGRect(
            x: 10,
            y: label.bottom + 3,
            width: contentView.width - postThumbnailImageView.width,
            height: 40
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnailImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    @objc private func didTapPost() {
        guard let id = postID else { return }
        delegate?.notificationsPostLikeTableViewCell(self, didTapPostWith: id)
    }
    
    func configure(with postFileName: String, model: Notification) {
        postThumbnailImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
        postID = postFileName
    }
    
}
