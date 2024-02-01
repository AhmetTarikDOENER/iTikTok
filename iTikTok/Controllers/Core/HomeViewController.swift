//
//  ViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit

class HomeViewController: UIViewController {

    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .systemBlue
        
        return scrollView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        setupFeed()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    //MARK: - Private
    private func setupFeed() {
        horizontalScrollView.contentSize = CGSize(
            width: view.width * 2,
            height: view.height
        )
        
        let pagingController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .vertical,
            options: [:]
        )
        
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        
        pagingController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false
        )
        pagingController.dataSource = self
        
        horizontalScrollView.addSubview(pagingController.view)
        pagingController.view.frame = view.bounds
        addChild(pagingController)
        pagingController.didMove(toParent: self)
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        nil
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = [.red, .gray, .green].randomElement()
        return vc
    }
}
