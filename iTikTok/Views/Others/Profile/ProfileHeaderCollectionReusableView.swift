//
//  ProfileHeaderCollectionReusableView.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 6.02.2024.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
