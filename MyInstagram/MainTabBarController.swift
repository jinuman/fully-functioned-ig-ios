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
        
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = UIColor.lightGray
        self.tabBar.isTranslucent = false
        
        // Home
        let homeNavigationController = HomeViewController
            .toNavigationController(isHiddenBar: false)
        homeNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "home_selected"),
            tag: MainTabType.home.rawValue
        )
            
        // Search
        let searchNavigationController = UserSearchController
            .toNavigationController(isHiddenBar: false)
        searchNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "search_selected"),
            tag: MainTabType.search.rawValue
        )
        
        
        let plusNavigationController = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "plus_unselected"),
            selectedImage: #imageLiteral(resourceName: "plus_unselected")
        )
        
        let likeNavigationController = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "like_unselected"),
            selectedImage: #imageLiteral(resourceName: "like_selected")
        )
        
        // user profile
        let userProfileNavigationController = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "profile_unselected"),
            selectedImage: #imageLiteral(resourceName: "profile_selected"),
            rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        )
        
        self.tabBar.tintColor = .black
        
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
