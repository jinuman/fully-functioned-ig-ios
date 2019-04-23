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
    
    private let headerId = "headerId"
    private let cellId = "cellId"
    private var user: User?
    private var posts = [Post]()
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView.register(UserProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerId)
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        fetchUser()
        setupLogOutButton()
        
        fetchOrderedPosts()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // Handling methods
    fileprivate func fetchOrderedPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { [weak self] (snapshot) in
          
            guard
                let self = self,
                let dictionary = snapshot.value as? [String : Any],
                let user = self.user,
                let post = Post(user: user, dictionary: dictionary) else { return }
            
            self.posts.insert(post, at: 0) // insert latest post on the top
            self.collectionView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUser(with: uid) { [weak self] (user) in
            guard let self = self else { return }
            
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSignOut))
    }
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] (_) in
            do {
                try Auth.auth().signOut()
                
                let signInController = SignInController()
                let navController = UINavigationController(rootViewController: signInController)
                self?.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                print("Failed to sign out: \(signOutErr.localizedDescription)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

// Regarding collectionView
extension UserProfileController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        let userProfileHeader = header as? UserProfileHeader
        userProfileHeader?.user = self.user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let userProfilePhotoCell = cell as? UserProfilePhotoCell
        userProfilePhotoCell?.post = posts[indexPath.item]
        return cell
    }
    
    // 행들 간 간격 return
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 행 안에 셀들 간 간격 return
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
}
