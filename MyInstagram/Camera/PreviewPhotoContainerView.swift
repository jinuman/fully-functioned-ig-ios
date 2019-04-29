//
//  PreviewPhotoContainerView.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 29/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class PreviewPhotoContainerView: UIView {
    
    // MARK:- Screen properties
    let previewImageView: UIImageView = {
        let iv = UIImageView()
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
        
    }
}
