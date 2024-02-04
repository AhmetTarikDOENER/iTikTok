//
//  ExploreManager.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 4.02.2024.
//

import UIKit

protocol ExploreManagerDelegate: AnyObject {
    func pushViewController(_ vc: UIViewController)
    func didTapHashtag(_ hashtag: String)
}

final class ExploreManager {
    
    static let shared = ExploreManager()
    private init() {}
    
    weak var delegate: ExploreManagerDelegate?
    
    enum BannerAction: String {
        case post
        case hashtag
        case user
    }
    
    //MARK: - Public
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreBannerData = parseExploreData() else { return [] }
        return exploreBannerData.banners.compactMap {
            model in
                .init(
                    image: UIImage(named: model.image),
                    title: model.title) {
                        [weak self] in
                        guard let action = BannerAction(rawValue: model.action) else { return }
                        DispatchQueue.main.async {
                            let vc = UIViewController()
                            vc.view.backgroundColor = .systemBackground
                            vc.title = action.rawValue.uppercased()
                            self?.delegate?.pushViewController(vc)
                        }
                        switch action {
                        case .post:
                            // Post
                            break
                        case .hashtag:
                            // Search for hashtag
                            break
                        case .user:
                            // Profile
                            break
                        }
                    }
        }
    }
    
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreCreatorData = parseExploreData() else { return [] }
        return exploreCreatorData.creators.compactMap {
            [weak self] model in
                .init(
                    profilePicture: UIImage(named: model.image),
                    username: model.username,
                    followerCount: model.followers_count) {
                        DispatchQueue.main.async {
                            let userID = model.id
                            // Fetch user object from firebase
                            let vc = ProfileViewController(
                                user: User(
                                    username: "Joe",
                                    profilePictureURL: nil,
                                    identifier: userID
                                )
                            )
                            self?.delegate?.pushViewController(vc)
                        }
                    }
        }
    }
    
    public func getExploreHashtag() -> [ExploreHashtagViewModel] {
        guard let exploreHastagData = parseExploreData() else { return [] }
        return exploreHastagData.hashtags.compactMap {
            model in
                .init(
                    text: "#" + model.tag,
                    icon: UIImage(named: model.image),
                    count: model.count) {
                        [weak self] in
                        DispatchQueue.main.async {
                            self?.delegate?.didTapHashtag(model.tag)
                        }
                    }
        }
    }
    
    public func getExploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreTrendingData = parseExploreData() else { return [] }
        return exploreTrendingData.trendingPosts.compactMap {
            model in
            .init(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption) {
                    [weak self] in
                    DispatchQueue.main.async {
                        // use id to fetch post from firebase
                        let vc = PostViewController(model: PostModel(identifier: model.id))
                        self?.delegate?.pushViewController(vc)
                    }
                }
        }
    }
    
    public func getExploreRecentPosts() -> [ExplorePostViewModel] {
        guard let exploreRecentData = parseExploreData() else { return [] }
        return exploreRecentData.trendingPosts.compactMap {
            model in
            .init(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption) {
                    [weak self] in
                    DispatchQueue.main.async {
                        // use id to fetch post from firebase
                        let vc = PostViewController(model: PostModel(identifier: model.id))
                        self?.delegate?.pushViewController(vc)
                    }
                }
        }
    }
    
    public func getExplorePopularPosts() -> [ExplorePostViewModel] {
        guard let explorePopularData = parseExploreData() else { return [] }
        return explorePopularData.popular.compactMap {
            model in
            .init(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption) {
                    [weak self] in
                    DispatchQueue.main.async {
                        // use id to fetch post from firebase
                        let vc = PostViewController(model: PostModel(identifier: model.id))
                        self?.delegate?.pushViewController(vc)
                    }
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
