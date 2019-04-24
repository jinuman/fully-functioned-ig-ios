//
//  SharePhotoController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 18/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    var selectedImage: UIImage? {
        didSet {
            self.postImageView.image = selectedImage
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupSubviews()
    }
    
    deinit {
        print("SharePhotoController \(#function)")
    }
    
    fileprivate func setupSubviews() {
        let guide = view.safeAreaLayoutGuide
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        containerView.anchor(top: guide.topAnchor,
                             leading: guide.leadingAnchor,
                             bottom: nil,
                             trailing: guide.trailingAnchor,
                             size: CGSize(width: 0, height: 100))
        
        [postImageView, captionTextView].forEach {
            containerView.addSubview($0)
        }
        
        postImageView.anchor(top: containerView.topAnchor,
                                  leading: containerView.leadingAnchor,
                                  bottom: containerView.bottomAnchor,
                                  trailing: nil,
                                  padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0),
                                  size: CGSize(width: 84, height: 0))
        
        captionTextView.anchor(top: containerView.topAnchor,
                                   leading: postImageView.trailingAnchor,
                                   bottom: containerView.bottomAnchor,
                                   trailing: containerView.trailingAnchor,
                                   padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0))
    }
    
    @objc func handleShare() {
        guard
            let caption = captionTextView.text,
            caption.isEmpty == false else { return }
        
        guard
            let image = selectedImage,
            let uploadData = image.jpegData(compressionQuality: 0.1) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = UUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { [weak self] (metadata, error) in
            
            guard let self = self else { return }
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print(error.localizedDescription)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadUrl, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                guard let imageUrl = downloadUrl?.absoluteString else { return }
                self.saveToDatabase(with: imageUrl)
            })
        }
    }
    
    fileprivate func saveToDatabase(with imageUrl: String) {
        guard
            let uid = Auth.auth().currentUser?.uid,
            let postImage = selectedImage,
            let caption = captionTextView.text else { return }
        
        // 사용자가 작성한 게시물 정보 저장
        let userPostRef = Database.database().reference().child("posts").child(uid).childByAutoId()
        
        let values = [
            "imageUrl" : imageUrl,
            "caption" : caption,
            "imageWidth" : postImage.size.width,
            "imageHeight" : postImage.size.height,
            "creationDate" : Date().timeIntervalSince1970
        ] as [String : Any]
        
        userPostRef.updateChildValues(values) { [weak self] (err, ref) in
            guard let self = self else { return }
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print(err.localizedDescription)
                return
            }
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
