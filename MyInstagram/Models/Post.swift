//
//  Post.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 22/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init?(dictionary: [String : Any]) {
        guard
            let imageUrl = dictionary["imageUrl"] as? String else { return nil }
        self.imageUrl = imageUrl
    }
}
