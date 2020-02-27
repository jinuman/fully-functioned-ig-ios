//
//  CommentCollectionViewCell.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 30/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " \(comment.text)", attributes: [.font : UIFont.systemFont(ofSize: 14)]))
            
            self.commentTextView.attributedText = attributedText
            self.profileImageView.loadImage(with: comment.user.profileImageUrl)
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
    
    // MARK:- Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews([
            self.profileImageView,
            self.commentTextView
        ])
        
        self.profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8.0)
            $0.size.equalTo(CGSize(all: 40))
        }
        
        self.profileImageView.layer.cornerRadius = 40 / 2
        
        self.commentTextView.snp.makeConstraints {
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(4)
            $0.top.trailing.bottom.equalToSuperview().inset(8.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
