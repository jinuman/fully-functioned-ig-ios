//
//  SignUpController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 03/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {

    // MARK:- Screen properties
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(validationCheckForSignUp), for: .editingChanged)
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(validationCheckForSignUp), for: .editingChanged)
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.textContentType = .password
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(validationCheckForSignUp), for: .editingChanged)
        return tf
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.loginColor
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already hava an account?  ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(r: 17, g: 154, b: 237)
            ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Life cycle methods need super call of itself.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviewsForSignUp()
    }
    
    // MARK:- Setup screen constraints method
    fileprivate func setupSubviewsForSignUp() {
        let guide = view.safeAreaLayoutGuide
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        [plusPhotoButton, stackView, alreadyHaveAccountButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            plusPhotoButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor)
            ])
        plusPhotoButton.anchor(top: guide.topAnchor, leading: nil, bottom: nil, trailing: nil,
                               padding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0),
                               size: CGSize(width: 140, height: 140))
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor,
                         leading: guide.leadingAnchor,
                         bottom: nil,
                         trailing: guide.trailingAnchor,
                         padding: UIEdgeInsets(top: 20, left: 40, bottom: 0, right: 40),
                         size: CGSize(width: 0, height: 200))
        
        alreadyHaveAccountButton.anchor(top: nil,
                                        leading: guide.leadingAnchor,
                                        bottom: guide.bottomAnchor,
                                        trailing: guide.trailingAnchor,
                                        size: CGSize(width: 0, height: 50))
    }
    
    // MARK:- Event handling methods
    @objc fileprivate func validationCheckForSignUp() {
        guard
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text else { return }
        guard
            email.isEmpty == false,
            username.isEmpty == false,
            password.isEmpty == false else {
                signUpButton.isEnabled = false
                signUpButton.backgroundColor = .loginColor
                return
        }
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = .enabledButtonColor
    }
    
    @objc fileprivate func handlePlusPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSignUp() {
        guard
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text else { return }
        
        // 신규 유저 생성
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, err) in
            if let err = err {
                print("Failed to create user: ", err.localizedDescription)
                return
            }
            print("\nSuccessfully created user: \(result?.user.uid ?? "")")
            
            guard
                let self = self,
                let image = self.plusPhotoButton.imageView?.image,
                let uploadData = image.jpegData(compressionQuality: 0.05) else {
                    return
            }
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            // Save into Storage
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to upload profile image: ", err.localizedDescription)
                    return
                }
                // In order to get image URL
                storageRef.downloadURL(completion: { [weak self] (url, err) in
                    if let err = err {
                        print("Failed to fetch download url: ", err.localizedDescription)
                        return
                    }
                    guard
                        let self = self,
                        let profileImageUrl = url?.absoluteString,
                        let uid = result?.user.uid else {
                            return
                    }
                    print("\nSuccessfully uploaded profile image: ", profileImageUrl)
                    
                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                    // child("users").child(uid) is same below
                    let values = [uid: dictionaryValues]
                    self.signUpUserIntoDatabase(with: uid, values: values)
                })
            })
            
        }
    }
    
    fileprivate func signUpUserIntoDatabase(with uid: String, values: [String: Any]) {
        let reference: DatabaseReference = Database.database().reference()
        reference.child("users").updateChildValues(values, withCompletionBlock: { [weak self] (err, ref) in
            if let err = err {
                print("Failed to save user into database: ", err.localizedDescription)
                return
            }
            print("\nSuccessfully saved user into database.")
            
            // Because of new user, refresh UI and dismiss
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {
                return
            }
            mainTabBarController.setupViewControllers()
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc fileprivate func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK:- Regarding Image Picker Controller
extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        guard let selectedImage = selectedImageFromPicker else { return }
        
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

