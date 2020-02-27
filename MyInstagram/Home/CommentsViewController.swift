//
//  CommentsViewController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 29/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

import Firebase

class CommentsViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: UI
    
    private lazy var guide = self.view.safeAreaLayoutGuide
    
    private lazy var commentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register([CommentCell.self])
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.contentInset.bottom = 50
        collectionView.scrollIndicatorInsets.bottom = 0
        
        return collectionView
    }()
    
    private lazy var commentInputAccessoryView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        let view = CommentInputAccessoryView(frame: frame)
        view.delegate = self
        return view
    }()
    
    
    // MARK: General
    
    var post: Post?
    var comments = [Comment]()
    
    override var inputAccessoryView: UIView? {
        get {
            return self.commentInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Initializing
    
    deinit {
        self.deinitLog(objectName: self.className)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        
        self.fetchComments()
    }
    
    // MARK: - Methods
    
    private func configureLayout() {
        self.navigationItem.title = "Comments"
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubviews([
            self.commentsCollectionView
        ])
        
        self.commentsCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.guide)
        }
    }
    
    private func fetchComments() {
        guard let postId = self.post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { [weak self] (snapshot) in
            
            guard
                let self = self,
                let dictionary = snapshot.value as? [String : Any],
                let uid = dictionary["uid"] as? String else { return }
            
            
            Database.fetchUser(with: uid, completion: { [weak self] (user) in
                guard let `self` = self,
                    let comment = Comment(user: user, dictionary: dictionary) else { return }
                self.comments.append(comment)
                self.commentsCollectionView.reloadData()
            })
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

// MARK: - Extensions

extension CommentsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int)
        -> Int
    {
        return self.comments.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(cellType: CommentCell.self, for: indexPath)
        cell.comment = self.comments[indexPath.item]
        return cell
    }
}

extension CommentsViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath)
        -> CGSize
    {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()  // after comment set
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        // Proper cell height for ImageView if text height is short
        let height = max(40 + 8 + 8, estimatedSize.height)  // profileImageView width + padding
        return CGSize(width: guide.layoutFrame.width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int)
        -> CGFloat
    {
        return 0
    }
}

extension CommentsViewController: CommentInputAccessoryViewDelegate {
    func didSend(for comment: String) {
        guard let uid = Auth.auth().currentUser?.uid,
            let postId = post?.id else { return }
        
        let values: [String: Any] = [
            "uid": uid,
            "creationDate": Date().timeIntervalSince1970,
            "text": comment
        ]
        
        Database.database().reference()
            .child("comments")
            .child(postId)
            .childByAutoId()
            .updateChildValues(values) { [weak self] (err, ref) in
                guard let `self` = self else { return }
                if let err = err {
                    print("Failed to insert comment:", err.localizedDescription)
                    return
                }
                
                log.debugPrint("Successfully inserted comment.", level: .debug)
                self.commentInputAccessoryView.clearCommentTextView()
        }
    }
}
