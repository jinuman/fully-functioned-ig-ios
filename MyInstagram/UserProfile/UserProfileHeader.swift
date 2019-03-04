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
            setupProfileImage()
            usernameLabel.text = user?.username
        }
    }
    
    // MARK:- Screen properties
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor,
                                leading: self.leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                marginTop: 12,
                                marginLeading: 12,
                                marginBottom: 0,
                                marginTrailing: 0,
                                width: 80,
                                height: 80)
        
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor,
                             leading: self.leadingAnchor,
                             bottom: gridButton.topAnchor,
                             trailing: self.trailingAnchor,
                             marginTop: 4,
                             marginLeading: 24,
                             marginBottom: 4,
                             marginTrailing: 24,
                             width: 0,
                             height: 0)
        
        setupUserStatsView()
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor,
                                 leading: postsLabel.leadingAnchor,
                                 bottom: nil,
                                 trailing: followingLabel.trailingAnchor,
                                 marginTop: 2,
                                 marginLeading: 0,
                                 marginBottom: 0,
                                 marginTrailing: 0,
                                 width: 0,
                                 height: 34)
    }
    
    fileprivate func setupProfileImage() {
        guard
            let profileImageUrl = user?.profileImageUrl ,
            let url = URL(string: profileImageUrl) else {
                return
        }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            // check for the error first. then construct the image by using data.
            if let err = err {
                print("Failed to fetch profile image: \(err.localizedDescription)")
                return
            }
            // perhaps check for response status of 200 (HTTP OK)..
            
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            // need to get back onto the main UI thread
            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
            print("\nSuccessfully fetch profile image: \(profileImageUrl)")
            }.resume()
    }
    
    fileprivate func setupBottomToolbar() {
        let topSeparatorView = UIView()
        topSeparatorView.backgroundColor = .lightGray
        
        let bottomSeparatorView = UIView()
        bottomSeparatorView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topSeparatorView)
        addSubview(bottomSeparatorView)
        
        stackView.anchor(top: nil,
                         leading: self.leadingAnchor,
                         bottom: self.bottomAnchor,
                         trailing: self.trailingAnchor,
                         marginTop: 0,
                         marginLeading: 0,
                         marginBottom: 0,
                         marginTrailing: 0,
                         width: 0,
                         height: 50)
        
        topSeparatorView.anchor(top: stackView.topAnchor,
                              leading: self.leadingAnchor,
                              bottom: nil,
                              trailing: self.trailingAnchor,
                              marginTop: 0,
                              marginLeading: 0,
                              marginBottom: 0,
                              marginTrailing: 0,
                              width: 0,
                              height: 0.5)
        
        bottomSeparatorView.anchor(top: stackView.bottomAnchor,
                                   leading: self.leadingAnchor,
                                   bottom: nil,
                                   trailing: self.trailingAnchor,
                                   marginTop: 0,
                                   marginLeading: 0,
                                   marginBottom: 0,
                                   marginTrailing: 0,
                                   width: 0,
                                   height: 0.5)
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
                         marginTop: 12,
                         marginLeading: 12,
                         marginBottom: 0,
                         marginTrailing: 12,
                         width: 0,
                         height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
