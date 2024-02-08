//
//  ExploreResponse.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 8.02.2024.
//

import Foundation

struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}
