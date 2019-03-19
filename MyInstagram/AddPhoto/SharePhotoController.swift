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
        
        setupImageAndTextView()
    }
    
    fileprivate func setupImageAndTextView() {
        let guide = view.safeAreaLayoutGuide
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: guide.topAnchor, leading: guide.leadingAnchor, bottom: nil, trailing: guide.trailingAnchor, marginTop: 0, marginLeading: 0, marginBottom: 0, marginTrailing: 0, width: 0, height: 100)
        
        containerView.addSubview(thumbnailImageView)
        thumbnailImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: nil, marginTop: 8, marginLeading: 8, marginBottom: 8, marginTrailing: 0, width: 84, height: 0)
    }
    
    @objc func handleShare() {
        print("share")
    }
}
