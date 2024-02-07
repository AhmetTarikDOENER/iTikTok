//
//  PostCollectionViewCell.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 7.02.2024.
//

import UIKit
import AVFoundation

class PostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubviews(imageView)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    func configure(with post: PostModel) {
        // Get download url
        StorageManager.shared.getDownloadURL(for: post) {
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    print("Got url: \(url)")
                    // Generate thumbnail
                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)
                    do {
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        self.imageView.image = UIImage(cgImage: cgImage)
                    } catch {
                        
                    }
                case .failure(let error):
                    print("Failed to get download url: \(error)")
                }
            }
        }
    }
    
}
