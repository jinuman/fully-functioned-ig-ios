//
//  MainTabBarController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 03/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tmpVC = ViewController()
        let navController = UINavigationController(rootViewController: tmpVC)
        
        viewControllers = [navController]
    }
}
