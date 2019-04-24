//
//  UserSearchCell.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 23/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(with: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    // MARK:- Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [profileImageView, usernameLabel, separatorView].forEach {
            addSubview($0)
        }
        
        profileImageView.centerYInSuperview()
        let width: CGFloat = 50
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil,
                                padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0),
                                size: CGSize(width: width, height: width))
        profileImageView.layer.cornerRadius = width / 2
        profileImageView.clipsToBounds = true
        
        usernameLabel.anchor(top: topAnchor,
                             leading: profileImageView.trailingAnchor,
                             bottom: bottomAnchor,
                             trailing: trailingAnchor,
                             padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        
        separatorView.anchor(top: nil,
                             leading: usernameLabel.leadingAnchor,
                             bottom: bottomAnchor,
                             trailing: trailingAnchor,
                             size: CGSize(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
