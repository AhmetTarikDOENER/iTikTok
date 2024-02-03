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
        case .banners:
            break
        case .users:
            break
        case .trendingPosts:
            break
        case .trendingHashtags:
            break
        case .recommended:
            break
        case .popular:
            break
        case .new:
            break
        }
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemTeal
        return cell
    }
}

extension ExploreViewController: UISearchBarDelegate {
    
}
