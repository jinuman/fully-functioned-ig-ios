//
//  UserProfileController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 03/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        fetchUserAndSetupTitle()
    }
    
    fileprivate func fetchUserAndSetupTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            let username = dictionary["username"] as? String
            self.navigationItem.title = username
            
        }) { (err) in
            print("Failed to fetch user: \(err.localizedDescription)")
        }
    }
    
}
