//
//  ExploreManager.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 4.02.2024.
//

import UIKit

final class ExploreManager {
    
    static let shared = ExploreManager()
    private init() {}
    //MARK: - Public
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreBannerData = parseExploreData() else { return [] }
        return exploreBannerData.banners.compactMap {
            .init(
                image: UIImage(named: $0.image),
                title: $0.title) {
                    
                }
        }
    }
    
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreCreatorData = parseExploreData() else { return [] }
        return exploreCreatorData.creators.compactMap {
            .init(
                profilePicture: UIImage(named: $0.image),
                username: $0.username,
                followerCount: $0.followers_count) {
                    
                }
        }
    }
    
    public func getExploreHashtag() -> [ExploreHashtagViewModel] {
        guard let exploreHastagData = parseExploreData() else { return [] }
        return exploreHastagData.hashtags.compactMap {
            .init(
                text: $0.tag,
                icon: UIImage(named: $0.image),
                count: $0.count) {
                    
                }
        }
    }
    
    public func getExploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreTrendingData = parseExploreData() else { return [] }
        return exploreTrendingData.trendingPosts.compactMap {
            .init(
                thumbnailImage: UIImage(named: $0.image),
                caption: $0.caption) {
                    
                }
        }
    }
    
    public func getExploreRecentPosts() -> [ExplorePostViewModel] {
        guard let exploreRecentData = parseExploreData() else { return [] }
        return exploreRecentData.trendingPosts.compactMap {
            .init(
                thumbnailImage: UIImage(named: $0.image),
                caption: $0.caption) {
                    
                }
        }
    }
    
    public func getExplorePopularPosts() -> [ExplorePostViewModel] {
        guard let explorePopularData = parseExploreData() else { return [] }
        return explorePopularData.popular.compactMap {
            .init(
                thumbnailImage: UIImage(named: $0.image),
                caption: $0.caption) {
                    
                }
        }
    }
    //MARK: - Private
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else { return nil }
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ExploreResponse.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
}
//MARK: - RESPONSE
struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}
//MARK: - JSON MODELS
struct Banner: Codable {
    let id: String
    let image: String
    let title: String
    let action: String
}

struct Post: Codable {
    let id: String
    let image: String
    let caption: String
}

struct Hashtag: Codable {
    let image: String
    let tag: String
    let count: Int
}

struct Creator: Codable {
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}
