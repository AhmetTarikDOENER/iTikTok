//
//  ViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()

    let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        return scrollView
    }()
    
    let control: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
        control.backgroundColor = nil
        control.selectedSegmentTintColor = .white
        
        return control
    }()
    
    let forYouPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    let followingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        setupFeed()
        horizontalScrollView.delegate = self
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setupHeaderButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    //MARK: - Private
    private func setupHeaderButtons() {
        control.addTarget(self, action: #selector(didChangeSegmentedControl(_:)), for: .valueChanged)
        navigationItem.titleView = control
    }
    
    @objc private func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(
            CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex), y: 0),
            animated: true
        )
    }
    
    private func setupFeed() {
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        setupFollowingFeed()
        setupForYouFeed()
    }
    
    private func setupFollowingFeed() {
        guard let model = followingPosts.first else { return }
        
        let vc = PostViewController(model: model)
        vc.delegate = self
        followingPageViewController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false
        )
        followingPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(followingPageViewController.view)
        
        followingPageViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: horizontalScrollView.width,
            height: horizontalScrollView.height
        )
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
    }
    
    private func setupForYouFeed() {
        guard let model = forYouPosts.first else { return }
        
        let vc = PostViewController(model: model)
        vc.delegate = self
        forYouPageViewController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false
        )
        forYouPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(forYouPageViewController.view)
        
        forYouPageViewController.view.frame = CGRect(
            x: view.width,
            y: 0,
            width: horizontalScrollView.width,
            height: horizontalScrollView.height
        )
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else { return nil }
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else { return nil }
        
        if index == 0 {
            return nil
        }
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        
        return vc
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else { return nil }
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else { return nil }
        
        guard index < (currentPosts.count - 1) else { return nil }
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        
        return vc
    }
    
    var currentPosts: [PostModel] {
        if horizontalScrollView.contentOffset.x == 0 {
            // @ Following Page
            return followingPosts
        }
        // @ For You Page
        return forYouPosts
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width / 2) {
            control.selectedSegmentIndex = 0
        } else if scrollView.contentOffset.x > (view.width / 2) {
            control.selectedSegmentIndex = 1
        }
    }
}

extension HomeViewController: PostViewControllerDelegate {
    
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        horizontalScrollView.isScrollEnabled = false
        if horizontalScrollView.contentOffset.x == 0 {
            // FollowingPage
            followingPageViewController.dataSource = nil
        } else {
            forYouPageViewController.dataSource = nil
        }
        
        let vc = CommentViewController(post: post)
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        
        let frame = CGRect(
            x: 0,
            y: view.height,
            width: view.width,
            height: view.height * 0.75
        )
        vc.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(
                x: 0,
                y: self.view.height - frame.height,
                width: frame.width,
                height: frame.height
            )
        }
    }
}
