//
//  UserProfileHeader.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 04/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate: class {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    weak var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            fetchProfileImage()
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
        }
    }
    
    // MARK:- Screen properties
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    private lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = .disabledButtonColor
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = .disabledButtonColor
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
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
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
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor,
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
    
    fileprivate func setupEditFollowButton() {
        guard
            let currentLoggedInUserId = Auth.auth().currentUser?.uid,
            let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            // edit profile
        } else {
            // check if following
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }
                if
                    let isFollowing = snapshot.value as? Int,
                    isFollowing == 1 {
                    
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    
                } else {
                    self.setupFollowStyle()
                }
            }
        }
    }
    
    @objc fileprivate func handleEditProfileOrFollow() {
        guard
            let currentLoggedInUserId = Auth.auth().currentUser?.uid,
            let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            // unfollow logic
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { [weak self] (err, ref) in
                guard let self = self else { return }
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                self.setupFollowStyle()
            }
            
        } else {
            // follow logic
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            
            let values = [
                userId : 1
            ]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = .white
                self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .enabledButtonColor
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    @objc fileprivate func handleChangeToListView() {
        listButton.tintColor = .enabledButtonColor
        gridButton.tintColor = .disabledButtonColor
        delegate?.didChangeToListView()
    }
    
    @objc fileprivate func handleChangeToGridView() {
        listButton.tintColor = .disabledButtonColor
        gridButton.tintColor = .enabledButtonColor
        delegate?.didChangeToGridView()
    }
}
