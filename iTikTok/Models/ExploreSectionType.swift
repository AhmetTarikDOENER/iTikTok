//
//  ExploreSectionType.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 3.02.2024.
//

import Foundation

enum ExploreSectionType: CaseIterable {
    case banners
    case users
    case trendingPosts
    case trendingHashtags
    case recommended
    case popular
    case new
    
    var title: String {
        switch self {
        case .banners:
            "Featured"
        case .users:
            "Popular Creators"
        case .trendingPosts:
            "Trending Videos"
        case .trendingHashtags:
            "Hashtags"
        case .recommended:
            "Recommended"
        case .popular:
            "Popular"
        case .new:
            "Recently Posted"
        }
    }
}
