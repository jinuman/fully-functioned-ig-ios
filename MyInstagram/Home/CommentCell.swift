//
//  CommentCell.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 30/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    // MARK:- Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
