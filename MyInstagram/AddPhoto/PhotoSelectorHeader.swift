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
        headerImageView.anchor(top: self.topAnchor,
                              leading: self.leadingAnchor,
                              bottom: self.bottomAnchor,
                              trailing: self.trailingAnchor,
                              marginTop: 0, marginLeading: 0, marginBottom: 0, marginTrailing: 0,
                              width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
