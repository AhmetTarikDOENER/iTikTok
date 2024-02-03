//
//  ExploreCell.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 3.02.2024.
//

import UIKit

enum ExploreCell {
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel)
}

