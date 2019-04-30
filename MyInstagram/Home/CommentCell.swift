//
//  CommentCell.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 30/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    // MARK:- Properties
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " \(comment.text)", attributes: [.font : UIFont.systemFont(ofSize: 14)]))
            
            commentTextView.attributedText = attributedText
            profileImageView.loadImage(with: comment.user.profileImageUrl)
        }
    }
    
    private let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let commentTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        return tv
    }()
    
    // MARK:- Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [profileImageView, commentTextView].forEach {
            addSubview($0)
        }
        
        profileImageView.anchor(top: topAnchor,
                                leading: leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0),
                                size: CGSize(width: 40, height: 40))
        profileImageView.layer.cornerRadius = 40 / 2
        
        commentTextView.anchor(top: topAnchor,
                               leading: profileImageView.trailingAnchor,
                               bottom: bottomAnchor,
                               trailing: trailingAnchor,
                               padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
