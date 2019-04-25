//
//  CustomImageView.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 22/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

var imageCache = [String : UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        self.image = nil // prevent image flickering
        
        // check cache for image first
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        // otherwise fire off a new download
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // collectionView.reloadData() 를 총 2번한다.. viewDidLoad(), .childAdded..
            // solution : If url isn't proper then return for just ditch
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }
        
        task.resume()
    }
}
