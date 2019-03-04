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
    
    let headerId = "headerId"
    var user: User?
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView.register(UserProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerId)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        fetchUserAndSetupTitle()
    }
    
    // Event methods
    fileprivate func fetchUserAndSetupTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard
                let self = self,
                let dictionary = snapshot.value as? [String: Any] else {
                    return
            }
            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            print("\nSuccessfully fetch user name: \(self.user!.username)")
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to fetch user: \(err.localizedDescription)")
        }
    }
}

// Regarding collectionView
extension UserProfileController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? UserProfileHeader else {
            fatalError("UserProfileHeader is not proper!")
        }
        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        guard
            let username = dictionary["username"] as? String,
            let profileImageUrl = dictionary["profileImageUrl"] as? String else {
                fatalError("User dictionary is not valid")
        }
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
}
