//
//  ExploreHashtagViewModel.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 3.02.2024.
//

import UIKit

struct ExploreHashtagViewModel {
    
    let text: String
    let icon: UIImage?
    let count: Int // number of posts associated with tag
    let handler: (() -> Void)
}
