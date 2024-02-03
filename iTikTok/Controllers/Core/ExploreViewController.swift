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
                    image: nil,
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
                        thumbnailImage: nil,
                        caption: "",
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
                            username: "",
                            followerCount: 0,
                            handler: {
                                
                            }
                        )
                    ),
                    .user(
                        viewModel: .init(
                            profilePictureURL: nil,
                            username: "",
                            followerCount: 0,
                            handler: {
                                
                            }
                        )
                    ),
                    .user(
                        viewModel: .init(
                            profilePictureURL: nil,
                            username: "",
                            followerCount: 0,
                            handler: {
                                
                            }
                        )
                    ),
                    .user(
                        viewModel: .init(
                            profilePictureURL: nil,
                            username: "",
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
                            icon: nil,
                            count: 1,
                            handler: {
                                
                            }
                        )
                    ),
                    .hashtag(
                        viewModel: .init(
                            text: "#foryou",
                            icon: nil,
                            count: 1,
                            handler: {
                                
                            }
                        )
                    ),
                    .hashtag(
                        viewModel: .init(
                            text: "#foryou",
                            icon: nil,
                            count: 1,
                            handler: {
                                
                            }
                        )
                    ),
                    .hashtag(
                        viewModel: .init(
                            text: "#foryou",
                            icon: nil,
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
                cells: [
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    ),
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    ),
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    ),
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    )
                ]
            )
        )
        // Popular
        sections.append(
            .init(
                type: .popular,
                cells: [
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    ),
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    ),
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    ),
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    )
                ]
            )
        )
        // New&recent
        sections.append(
            .init(
                type: .new,
                cells: [
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    ),
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    ),
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    ),
                    .post(
                        viewModel: .init(
                            thumbnailImage: nil,
                            caption: "",
                            handler: {
                                
                            }
                        )
                    )
                ]
            )
        )
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout {
            section, _ -> NSCollectionLayoutSection in
            return self.layout(for: section)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
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
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            // Create SectionLayout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
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
                    heightDimension: .absolute(240)
                ),
                subitem: item, count: 2
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(240)
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
            break
        case .post(let viewModel):
            break
        case .hashtag(let viewModel):
            break
        case .user(let viewModel):
            break
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemTeal
        return cell
    }
}

extension ExploreViewController: UISearchBarDelegate {
    
}
