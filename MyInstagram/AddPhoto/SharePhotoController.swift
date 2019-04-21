//
//  SharePhotoController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 18/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
    
    let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    var selectedImage: UIImage? {
        didSet {
            self.thumbnailImageView.image = selectedImage
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupSubviews()
    }
    
    fileprivate func setupSubviews() {
        let guide = view.safeAreaLayoutGuide
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        containerView.anchor(top: guide.topAnchor,
                             leading: guide.leadingAnchor,
                             bottom: nil,
                             trailing: guide.trailingAnchor,
                             size: CGSize(width: 0, height: 100))
        
        [thumbnailImageView, captionTextView].forEach {
            containerView.addSubview($0)
        }
        
        thumbnailImageView.anchor(top: containerView.topAnchor,
                                  leading: containerView.leadingAnchor,
                                  bottom: containerView.bottomAnchor,
                                  trailing: nil,
                                  padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0),
                                  size: CGSize(width: 84, height: 0))
        
        captionTextView.anchor(top: containerView.topAnchor,
                                   leading: thumbnailImageView.trailingAnchor,
                                   bottom: containerView.bottomAnchor,
                                   trailing: containerView.trailingAnchor,
                                   padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0))
    }
    
    #warning("Need to implement with Firebase")
    @objc func handleShare() {
        print("share")
    }
}
