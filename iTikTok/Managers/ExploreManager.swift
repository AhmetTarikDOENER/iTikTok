//
//  ExploreManager.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 4.02.2024.
//

import UIKit

/// Delegate interface to notify manager events
protocol ExploreManagerDelegate: AnyObject {
    /// Notify a view controller should be pushed
    /// - Parameter vc: The view controller to present
    func pushViewController(_ vc: UIViewController)
    /// Notify a hashtag element was tapped
    /// - Parameter hashtag: The hashtag that was tapped
    func didTapHashtag(_ hashtag: String)
}

/// Manager that handles explore view content
final class ExploreManager {
    
    /// Shared singleton instance
    static let shared = ExploreManager()
    private init() {}
    
    /// Delegate to notify of events
    weak var delegate: ExploreManagerDelegate?
    
    /// Represents banner action type
    enum BannerAction: String {
        case post
        case hashtag
        case user
    }
    
    //MARK: - Public
    /// Gets explore data for banner
    /// - Returns: Collection of models
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
    /// Gets explore data for creators
    /// - Returns: Collection of models
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
    /// Gets explore data for hashtag
    /// - Returns: Collection of models
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
    /// Gets explore data for trending posts
    /// - Returns: Collection of models
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
                        let vc = PostViewController(
                            model: PostModel(
                                identifier: model.id,
                                user: User(
                                    username: "ahmez",
                                    profilePictureURL: nil,
                                    identifier: UUID().uuidString
                                )
                            )
                        )
                        self?.delegate?.pushViewController(vc)
                    }
                }
        }
    }
    
    /// Gets explore data for recent posts
    /// - Returns: Collection of models
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
                        let vc = PostViewController(
                            model: PostModel(
                                identifier: model.id,
                                user: User(
                                    username: "ahmez",
                                    profilePictureURL: nil,
                                    identifier: UUID().uuidString
                                )
                            )
                        )
                        self?.delegate?.pushViewController(vc)
                    }
                }
        }
    }
    
    /// Gets explore data for popular posts
    /// - Returns: Collection of models
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
                        let vc = PostViewController(
                            model: PostModel(
                                identifier: model.id,
                                user: User(
                                    username: "ahmez",
                                    profilePictureURL: nil,
                                    identifier: UUID().uuidString
                                )
                            )
                        )
                        self?.delegate?.pushViewController(vc)
                    }
                }
        }
    }
    //MARK: - Private
    /// Parses explore JSON data
    /// - Returns: Optional response model
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
