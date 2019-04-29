//
//  PreviewPhotoContainerView.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 29/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    // MARK:- Screen properties
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
        [previewImageView, cancelButton, saveButton].forEach {
            addSubview($0)
        }
        previewImageView.fillSuperview()
        
        cancelButton.anchor(top: topAnchor,
                            leading: leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 0),
                            size: CGSize(width: 50, height: 50))
        
        saveButton.anchor(top: nil,
                          leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: nil,
                          padding: UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 0),
                          size: CGSize(width: 50, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MAKR:- Handling methods
    @objc fileprivate func handleCancel() {
        self.removeFromSuperview()
    }
    
    @objc fileprivate func handleSave() {
        guard let previewImage = previewImageView.image else { return }
        
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
        }) { (success, error) in
            if let error = error {
                print("Failed to save image to photo library: ", error.localizedDescription)
                return
            }
            
            print("Successfully saved image to library")
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.textColor = .white
                savedLabel.textAlignment = .center
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.numberOfLines = 0
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.center
                
                self.addSubview(savedLabel)
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                }, completion: { (completed) in
                    
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                        
                    }, completion: { (_) in
                        
                        savedLabel.removeFromSuperview()
                        
                    })
                    
                })
            }
        }
    }
}
