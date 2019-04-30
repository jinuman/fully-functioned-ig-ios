//
//  Comment.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 30/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import Foundation

struct Comment {
    
    let user: User
    let uid: String
//    let creationDate
    let text: String
    
    init?(user: User, dictionary: [String : Any]) {
        guard
            let uid = dictionary["uid"] as? String,
            let text = dictionary["text"] as? String else { return nil }
        
        self.user = user
        self.uid = uid
        self.text = text
    }
}
