//
//  CommentsController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 29/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController {
    
    var post: Post?
    private let cellId = "cellId"
    var comments = [Comment]()
    
    private lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("SEND", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        
        [self.commentTextField, sendButton, lineSeparatorView].forEach {
            containerView.addSubview($0)
        }
        
        self.commentTextField.anchor(top: nil,
                                     leading: containerView.leadingAnchor,
                                     bottom: nil,
                                     trailing: sendButton.leadingAnchor,
                                     padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
        self.commentTextField.centerYInSuperview()
        self.commentTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        sendButton.anchor(top: nil,
                          leading: nil,
                          bottom: nil,
                          trailing: containerView.trailingAnchor,
                          size: CGSize(width: 80, height: 0))
        sendButton.centerYInSuperview()
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        lineSeparatorView.anchor(top: containerView.topAnchor,
                                 leading: containerView.leadingAnchor,
                                 bottom: nil,
                                 trailing: containerView.trailingAnchor,
                                 size: CGSize(width: 0, height: 0.5))
        
        return containerView
    }()
    
    private let commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter comments.."
        return tf
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .white
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
//        collectionView.contentInset.bottom = -50
//        collectionView.scrollIndicatorInsets.bottom = -50
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        print("CommentsController \(#function)")
    }
    
    @objc fileprivate func handleSend() {
        guard
            let uid = Auth.auth().currentUser?.uid,
            let postId = post?.id,
            let comment = commentTextField.text else { return }
        
        let values = [
            "uid" : uid,
            "creationDate" : Date().timeIntervalSince1970,
            "text" : comment
        ] as [String : Any]
        
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to insert comment:", err.localizedDescription)
                return
            }
            
            print("Successfully inserted comment.")
        }
    }
    
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { [weak self] (snapshot) in
            
            guard
                let self = self,
                let dictionary = snapshot.value as? [String : Any],
                let uid = dictionary["uid"] as? String else { return }
            
            
            Database.fetchUser(with: uid, completion: { (user) in
                guard let comment = Comment(user: user, dictionary: dictionary) else { return }
                self.comments.append(comment)
                self.collectionView.reloadData()
            })
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension CommentsController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CommentCell else {
            fatalError("Failed to cast CommentCell")
        }
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let guide = view.safeAreaLayoutGuide
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
