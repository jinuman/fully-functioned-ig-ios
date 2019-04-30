//
//  HomePostCell.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 22/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate: class {
    func didTapComment(post: Post)
    func didLike(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    weak var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            self.photoImageView.loadImage(with: postImageUrl)
            
            usernameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(with: profileImageUrl)
            
            setupAttributedCaption()
            
            let likeButtonImage: UIImage = post?.hasLiked == true
                ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal)
                : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal)
            likeButton.setImage(likeButtonImage, for: .normal)
        }
    }
    
    let userProfileImageView: CustomImageView = {
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
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal) // option + 8
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK:- Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [userProfileImageView, usernameLabel, optionsButton, photoImageView, captionLabel].forEach {
            addSubview($0)
        }
        
        userProfileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                                    padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0),
                                    size: CGSize(width: 40, height: 40))
        userProfileImageView.layer.cornerRadius = 40 / 2
        userProfileImageView.clipsToBounds = true
        
        usernameLabel.anchor(top: topAnchor,
                             leading: userProfileImageView.trailingAnchor,
                             bottom: photoImageView.topAnchor,
                             trailing: optionsButton.leadingAnchor,
                             padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        
        optionsButton.anchor(top: topAnchor, leading: nil, bottom: photoImageView.topAnchor, trailing: trailingAnchor,
                             size: CGSize(width: 44, height: 0))
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor,
                              leading: leadingAnchor,
                              bottom: nil,
                              trailing: trailingAnchor,
                              padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionButtons()
        
        captionLabel.anchor(top: likeButton.bottomAnchor,
                            leading: leadingAnchor,
                            bottom: bottomAnchor,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Screen methods
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        
        [stackView, bookmarkButton].forEach {
            addSubview($0)
        }
        
        stackView.anchor(top: photoImageView.bottomAnchor,
                         leading: leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0),
                         size: CGSize(width: 120, height: 50))
        
        bookmarkButton.anchor(top: photoImageView.bottomAnchor,
                              leading: nil,
                              bottom: nil,
                              trailing: trailingAnchor,
                              size: CGSize(width: 40, height: 50))
    }
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.gray]))
        
        captionLabel.attributedText = attributedText
    }
    
    @objc fileprivate func handleComment() {
        guard let post = self.post else { return }
        
        delegate?.didTapComment(post: post)
    }
    
    @objc fileprivate func handleLike() {
        delegate?.didLike(for: self)
    }
}
