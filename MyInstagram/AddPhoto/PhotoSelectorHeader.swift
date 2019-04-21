//
//  PhotoSelectorHeader.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 18/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerImageView)
        headerImageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
