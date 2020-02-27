//
//  HomeViewController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 22/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

import SnapKit
import Firebase

class HomeViewController: UIViewController {
    
    var posts = [Post]()
    
    private lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register([HomePostCollectionViewCell.self])
        return collectionView
    }()
    
    // MARK: - Initializing
    
    deinit {
        
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationItems()
        self.configureLayout()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleUpdateFeed),
            name: SharePhotoController.updateFeedNotificationName,
            object: nil
        )
        
        self.fetchAllPosts()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator)
    {
        self.postCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Methods
    
    private func configureNavigationItems() {
        guard let cameraImage: UIImage = UIImage(named: "camera3"),
        let logoImage: UIImage = UIImage(named: "logo2") else { return }
        
        self.navigationItem.titleView = UIImageView(image: logoImage)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: cameraImage.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(self.handleCamera)
        )
    }
    
    private func configureLayout() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.postCollectionView.refreshControl = refreshControl
        
        self.view.addSubview(self.postCollectionView)
        
        self.postCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func handleCamera() {
        let cameraController = CameraController()
        self.present(cameraController, animated: true, completion: nil)
    }
    
    @objc private func handleUpdateFeed() {
        self.handleRefresh()
    }
    
    @objc private func handleRefresh() {
        self.posts.removeAll()
        self.fetchAllPosts()
    }
    
    private func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    private func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUser(with: uid) { [weak self] (user) in
            guard let self = self else { return }
            self.fetchPosts(with: user)
        }
    }
    
    private func fetchFollowingUserIds() {
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
    
    private func fetchPosts(with user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard
                let self = self,
                let dictionaries = snapshot.value as? [String : Any] else { return }
            
            self.postCollectionView.refreshControl?.endRefreshing()
            
            dictionaries.forEach({ (key, value) in
                guard
                    let dictionary = value as? [String : Any],
                    var post = Post(user: user, dictionary: dictionary),
                    let uid = Auth.auth().currentUser?.uid else { return }
                
                post.id = key
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if
                        let value = snapshot.value as? Int,
                        value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    
                    self.posts.sort(by: { (p0, p1) -> Bool in
                        return p0.creationDate.compare(p1.creationDate) == .orderedDescending
                    })
                    self.postCollectionView.reloadData()
                    
                }, withCancel: { (error) in
                    print("Failed to fetch like for post: ", error.localizedDescription)
                })
                
            })
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

// MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int)
        -> Int
    {
        return self.posts.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(
            cellType: HomePostCollectionViewCell.self,
            for: indexPath)
        
        if indexPath.item < posts.count {
            cell.post = posts[indexPath.item]
        }
        
        cell.delegate = self
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize
    {
        let width: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width
        var height: CGFloat = 40 + 8 + 8 // userProfileImageView + padding
        height += width
        height += 50  // several buttons field
        height += 60 // caption field
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: HomePostCellDelegate {
    func didTapComment(post: Post) {
        let commentsViewController = CommentsViewController()
        commentsViewController.post = post
        commentsViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
    
    func didLike(for cell: HomePostCollectionViewCell) {
        guard let indexPath = postCollectionView.indexPath(for: cell) else { return }
        
        var post = self.posts[indexPath.item]
        
        guard
            let postId = post.id,
            let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid : post.hasLiked ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { [weak self] (err, ref) in
            guard let self = self else { return }
            
            if let err = err {
                print("Failed to like post: ", err.localizedDescription)
                return
            }
            
            print("Successfully liked post.")
            post.hasLiked = !post.hasLiked
            
            self.posts[indexPath.item] = post
            
            self.postCollectionView.reloadItems(at: [indexPath])
        }
    }
}
