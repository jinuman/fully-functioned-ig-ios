//
//  Comment.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 30/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import Foundation

struct Comment {
    let uid: String
//    let creationDate
    let text: String
    
    init?(dictionary: [String : Any]) {
        guard
            let uid = dictionary["uid"] as? String,
            let text = dictionary["text"] as? String else { return nil }
        
        self.uid = uid
        self.text = text
    }
}
