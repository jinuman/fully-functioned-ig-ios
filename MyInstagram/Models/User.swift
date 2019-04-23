//
//  User.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 23/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        guard
            let username = dictionary["username"] as? String,
            let profileImageUrl = dictionary["profileImageUrl"] as? String else {
                fatalError("User dictionary is not valid")
        }
        self.uid = uid
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
}
