//
//  Post.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 22/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import Foundation

struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    init?(user: User, dictionary: [String : Any]) {
        guard
            let imageUrl = dictionary["imageUrl"] as? String,
            let caption = dictionary["caption"] as? String else { return nil }
        self.user = user
        self.imageUrl = imageUrl
        self.caption = caption
    }
}
