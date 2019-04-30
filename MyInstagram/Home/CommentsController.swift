//
//  CommentsController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 29/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {
    
    private lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("SEND", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        let textField = UITextField()
        textField.placeholder = "Enter comment.."
        
        [textField, sendButton].forEach {
            containerView.addSubview($0)
        }
        
        textField.anchor(top: nil,
                         leading: containerView.leadingAnchor,
                         bottom: nil,
                         trailing: sendButton.leadingAnchor,
                         padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
        textField.centerYInSuperview()
        textField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        sendButton.anchor(top: nil,
                          leading: nil,
                          bottom: nil,
                          trailing: containerView.trailingAnchor,
                          size: CGSize(width: 80, height: 0))
        sendButton.centerYInSuperview()
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        return containerView
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
        
    }
}
