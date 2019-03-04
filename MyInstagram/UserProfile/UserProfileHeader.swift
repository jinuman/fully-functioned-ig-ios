//
//  UserProfileHeader.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 04/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            setupProfileImage()
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor,
                                leading: self.leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                marginTop: 12,
                                marginLeading: 12,
                                marginBottom: 0,
                                marginTrailing: 0,
                                width: 80,
                                height: 80)
        
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
    }
    
    fileprivate func setupProfileImage() {
        guard
            let profileImageUrl = user?.profileImageUrl ,
            let url = URL(string: profileImageUrl) else {
                return
        }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            // check for the error first. then construct the image by using data.
            if let err = err {
                print("Failed to fetch profile image: \(err.localizedDescription)")
                return
            }
            // perhaps check for response status of 200 (HTTP OK)..
            
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            // need to get back onto the main UI thread
            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
            print("\nSuccessfully fetch profile image: \(profileImageUrl)")
        }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
