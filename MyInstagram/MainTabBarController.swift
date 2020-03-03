//
//  MainTabBarController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 03/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Firebase


enum MainTabType: Int {
    case home = 0
    case search
    case photo
    case like
    case profile
}

class MainTabBarController: UITabBarController {
    
    // MARK: - Initializing
    
    deinit {
        self.deinitLog(objectName: self.className)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self    // UITabBarControllerDelegate
        
        self.checkUserIsLoggedIn()
        self.configureViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkUserIsLoggedIn()
        self.configureViewControllers()
    }
    
    // MARK: - Methods
    
    // Refresh UI by logged in user.
    func configureViewControllers() {
        
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .white
        
        // Home
        let homeNavigationController = HomeViewController
            .toNavigationController(isHiddenBar: false)
        
        homeNavigationController.tabBarItem = UITabBarItem(
            unselectedImage: UIImage(named: "home_unselected"),
            selectedImage: UIImage(named: "home_selected"),
            tabType: .home
        )
            
        // Search
        let searchNavigationController = UserSearchController
            .toNavigationController(isHiddenBar: false)
        
        searchNavigationController.tabBarItem = UITabBarItem(
            unselectedImage: UIImage(named: "search_unselected"),
            selectedImage: UIImage(named: "search_selected"),
            tabType: .search
        )
        
        let plusNavigationController = UIViewController
            .toNavigationController(isHiddenBar: false)
        
        plusNavigationController.tabBarItem = UITabBarItem(
            unselectedImage: UIImage(named: "plus_unselected"),
            selectedImage: UIImage(named: "plus_selected"),
            tabType: .photo
        )
        
        let likeNavigationController = UIViewController
            .toNavigationController(isHiddenBar: false)
        
        likeNavigationController.tabBarItem = UITabBarItem(
            unselectedImage: UIImage(named: "like_unselected"),
            selectedImage: UIImage(named: "like_selected"),
            tabType: .like
        )
        
        // user profile
        let userProfileNavigationController = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "profile_unselected"),
            selectedImage: #imageLiteral(resourceName: "profile_selected"),
            rootViewController: MyProfileViewController()
        )
        
        self.viewControllers = [
            homeNavigationController,
            searchNavigationController,
            plusNavigationController,
            likeNavigationController,
            userProfileNavigationController
        ]
        
        guard let items = self.tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    private func templateNavigationController(
        unselectedImage: UIImage,
        selectedImage: UIImage,
        rootViewController: UIViewController = UIViewController())
        -> UINavigationController
    {
        let viewController = rootViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        return navigationController
    }
    
    private func checkUserIsLoggedIn() {
        // If user is not logged in
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let signInController = SignInController()
                let navController = UINavigationController(rootViewController: signInController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
    }
    
}

// MARK: - Extensions

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            self.present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
