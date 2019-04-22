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
    var cntNum: Int = 0
    var post: Post? {
        didSet {
            cntNum += 1
            print("post called \(cntNum)")
            guard let imageUrl = post?.imageUrl else { return }
            self.photoImageView.loadImage(with: imageUrl)
        }
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
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
