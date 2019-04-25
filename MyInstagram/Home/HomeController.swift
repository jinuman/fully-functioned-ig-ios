//
//  HomeController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 22/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
    
    private let cellId = "cellId"
    var posts = [Post]()
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed),
                                               name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView.backgroundColor = .white
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        setupNavigationItems()
        
        fetchAllPosts()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    deinit {
        print("HomeController \(#function)")
    }
    
    // MARK:- Screen methods
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    // MARK:- Handling methods
    @objc fileprivate func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc fileprivate func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUser(with: uid) { [weak self] (user) in
            guard let self = self else { return }
            self.fetchPosts(with: user)
        }
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(currentUid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String : Any] else { return }
            userIdsDictionary.forEach({ (key, value) in
                let uid = key
                Database.fetchUser(with: uid, completion: { [weak self] (user) in
                    guard let self = self else { return }
                    self.fetchPosts(with: user)
                })
            })
            
        }) { (err) in
            print("Failed to fetch following user ids: ", err.localizedDescription)
        }
    }
    
    fileprivate func fetchPosts(with user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard
                let self = self,
                let dictionaries = snapshot.value as? [String : Any] else { return }
            
            self.collectionView.refreshControl?.endRefreshing()
            
            dictionaries.forEach({ (key, value) in
                guard
                    let dictionary = value as? [String : Any],
                    let post = Post(user: user, dictionary: dictionary) else { return }
                
                self.posts.append(post)
            })
            self.posts.sort(by: { (p0, p1) -> Bool in
                return p0.creationDate.compare(p1.creationDate) == .orderedDescending
            })
            self.collectionView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

// MARK:- Regarding CollectionView
extension HomeController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomePostCell else {
            fatalError("Failed to cast HomePostCell")
        }
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width
        var height: CGFloat = 40 + 8 + 8 // userProfileImageView + padding
        height += width
        height += 50  // several buttons field
        height += 60 // caption field
        return CGSize(width: width, height: height)
    }
}
