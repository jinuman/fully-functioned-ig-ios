//
//  Firebase+MyInstagram.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 23/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUser(with uid: String, completion: @escaping (User) -> ()) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String : Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}
