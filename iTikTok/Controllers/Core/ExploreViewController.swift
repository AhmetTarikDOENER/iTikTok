//
//  ExploreViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search what you want to see"
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        
        return bar
    }()
    
    private var collectionView: UICollectionView?
    private var sections = [ExploreSection]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureModels()
        setupSearchBar()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    //MARK: - Private
    private func setupSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureModels() {
        // Banner
        var cells = [ExploreCell]()
        for _ in 0...100 {
            let cell = ExploreCell.banner(
                viewModel: .init(
                    image: UIImage(named: "test"),
                    title: "Test",
                    handler: {
                        
                    }
                )
            )
            cells.append(cell)
        }
        
        sections.append(ExploreSection(type: .banners, cells: cells))
        
        // TrendingPosts
        var posts = [ExploreCell]()
        for _ in 0...40 {
            posts.append(
                ExploreCell.post(
                    viewModel: .init(
                        thumbnailImage: UIImage(named: "test"),
                        caption: "This was a really cool post and very very long post",
                        handler: {
                            
                        }
                    )
                )
            )
        }
        sections.append(
            .init(
                type: .trendingPosts,
                cells: posts
            )
        )
        // Users
        sections.append(
            .init(
                type: .users,
                cells: [
                    .user(
                        viewModel: .init(
                            profilePictureURL: nil,
                            username: "AhmetTarik",
                            followerCount: 0,
                            handler: {
                                
                            }
                        )
                    ),
                    .user(
                        viewModel: .init(
                            profilePictureURL: nil,
                            username: "Enes",
                            followerCount: 0,
                            handler: {
                                
                            }
                        )
                    ),
                    .user(
                        viewModel: .init(
                            profilePictureURL: nil,
                            username: "Emilia",
                            followerCount: 0,
                            handler: {
                                
                            }
                        )
                    ),
                    .user(
                        viewModel: .init(
                            profilePictureURL: nil,
                            username: "Milka",
                            followerCount: 0,
                            handler: {
                                
                            }
                        )
                    )
                ]
            )
        )
        // Trending Hashtags
        sections.append(
            .init(
                type: .trendingHashtags,
                cells: [
                    .hashtag(
                        viewModel: .init(
                            text: "#foryou",
                            icon: UIImage(systemName: "house"),
                            count: 1,
                            handler: {
                                
                            }
                        )
                    ),
                    .hashtag(
                        viewModel: .init(
                            text: "#iphone12",
                            icon: UIImage(systemName: "camera"),
                            count: 1,
                            handler: {
                                
                            }
                        )
                    ),
                    .hashtag(
                        viewModel: .init(
                            text: "#tiktokcourse",
                            icon: UIImage(systemName: "airplane"),
                            count: 1,
                            handler: {
                                
                            }
                        )
                    ),
                    .hashtag(
                        viewModel: .init(
                            text: "#m1Macbook",
                            icon: UIImage(systemName: "bell"),
                            count: 1,
                            handler: {
                                
                            }
                        )
                    )
                ]
            )
        )
        // Recommendend
        sections.append(
            .init(
                type: .recommended,
                cells: posts
            )
        )
        // Popular
        sections.append(
            .init(
                type: .popular,
                cells: posts
            )
        )
        // New&recent
        sections.append(
            .init(
                type: .new,
                cells: posts
            )
        )
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout {
            section, _ -> NSCollectionLayoutSection in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            ExploreBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier
        )
        collectionView.register(
            ExplorePostCollectionViewCell.self,
            forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier
        )
        collectionView.register(
            ExploreUserCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier
        )
        collectionView.register(
            ExploreHashtagCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        switch model {
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreBannerCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreBannerCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExplorePostCollectionViewCell.identifier,
                for: indexPath
            ) as? ExplorePostCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: viewModel)
            return cell
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreHashtagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: viewModel)
            return cell
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreUserCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreUserCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let model = sections[indexPath.section].cells[indexPath.row]
        switch model {
        case .banner(let viewModel):
            break
        case .post(let viewModel):
            break
        case .hashtag(let viewModel):
            break
        case .user(let viewModel):
            break
        }
    }
}

//MARK: - UISearchBarDelegate
extension ExploreViewController: UISearchBarDelegate {
    
}

//MARK: - Section Layouts
extension ExploreViewController {
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        
        switch sectionType {
            //MARK: - BANNER
        case .banners:
            // Create Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            // Create Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            // Create SectionLayout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            return sectionLayout
            
            //MARK: - USERS
        case .users:
            // Create Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            // Create Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(150)
                ),
                subitems: [item]
            )
            // Create SectionLayout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            return sectionLayout
            
            //MARK: - TRENDINGHASHTAGS
        case .trendingHashtags:
            // Create Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            // Create Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitems: [item]
            )
            // Create SectionLayout
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            return sectionLayout
            
            //MARK: - TRENDINGPOSTS, NEW, RECOMMENDED
        case .trendingPosts, .new, .recommended:
            // Create Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            // Create Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(300)
                ),
                subitem: item, count: 2
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(300)
                ),
                subitems: [verticalGroup]
            )
            // Create SectionLayout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            return sectionLayout
            
            //MARK: - POPULAR
        case .popular:
            // Create Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            // Create SectionLayout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            return sectionLayout
        }
    }

}
