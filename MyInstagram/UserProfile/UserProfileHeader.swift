//
//  UserProfileHeader.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 04/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            fetchProfileImage()
            usernameLabel.text = user?.username
        }
    }
    
    // MARK:- Screen properties
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n",
                                                       attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts",
                                                 attributes: [
                                                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n",
                                                       attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers",
                                                 attributes: [
                                                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n",
                                                       attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following",
                                                 attributes: [
                                                    NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK:- Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        setupProfileImageView()
        
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor,
                             leading: self.leadingAnchor,
                             bottom: gridButton.topAnchor,
                             trailing: self.trailingAnchor,
                             padding: UIEdgeInsets(top: 4, left: 24, bottom: 4, right: 24))
        
        setupUserStatsView()
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor,
                                 leading: postsLabel.leadingAnchor,
                                 bottom: nil,
                                 trailing: followingLabel.trailingAnchor,
                                 padding: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0),
                                 size: CGSize(width: 0, height: 34))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Screen methods
    fileprivate func setupProfileImageView() {
        profileImageView.anchor(top: self.topAnchor,
                                leading: self.leadingAnchor,
                                bottom: nil,
                                trailing: nil, padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 0),
                                size: CGSize(width: 80, height: 80))
    }
    
    fileprivate func setupBottomToolbar() {
        let topSeparatorView = UIView()
        topSeparatorView.backgroundColor = .lightGray
        
        let bottomSeparatorView = UIView()
        bottomSeparatorView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        [stackView, topSeparatorView, bottomSeparatorView].forEach {
            addSubview($0)
        }
        
        stackView.anchor(top: nil,
                         leading: self.leadingAnchor,
                         bottom: self.bottomAnchor,
                         trailing: self.trailingAnchor,
                         size: CGSize(width: 0, height: 50))
        
        topSeparatorView.anchor(top: stackView.topAnchor,
                                leading: self.leadingAnchor,
                                bottom: nil,
                                trailing: self.trailingAnchor,
                                size: CGSize(width: 0, height: 0.5))
        
        bottomSeparatorView.anchor(top: stackView.bottomAnchor,
                                leading: self.leadingAnchor,
                                bottom: nil,
                                trailing: self.trailingAnchor,
                                size: CGSize(width: 0, height: 0.5))
    }
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: self.topAnchor,
                         leading: profileImageView.trailingAnchor,
                         bottom: nil,
                         trailing: self.trailingAnchor,
                         padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12),
                         size: CGSize(width: 0, height: 50))

    }
    
    fileprivate func fetchProfileImage() {
        profileImageView.layer.cornerRadius =  profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        guard let profileImageUrl = user?.profileImageUrl else { return }
        profileImageView.loadImage(with: profileImageUrl)
    }
}
