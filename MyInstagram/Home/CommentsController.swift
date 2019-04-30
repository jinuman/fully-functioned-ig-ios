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
    
    private lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("SEND", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        [self.commentTextField, sendButton].forEach {
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
        collectionView.backgroundColor = .red
        
//        collectionView.contentInset.bottom = -50
//        collectionView.scrollIndicatorInsets.bottom = -50
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
        
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { [weak self] (err, ref) in
            guard let self = self else { return }
            
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
        ref.observe(.childAdded, with: { (snapshot) in
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension CommentsController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CommentCell else {
            fatalError("Failed to cast CommentCell")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let guide = view.safeAreaLayoutGuide
        return CGSize(width: guide.layoutFrame.width, height: 50)
    }
}
