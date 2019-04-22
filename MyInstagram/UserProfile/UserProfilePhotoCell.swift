//
//  UserProfilePhotoCell.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 22/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    // MARK:- Cell properties
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            self.photoImageView.loadImageUsingCache(with: imageUrl)
        }
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK:- Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
