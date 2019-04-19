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
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(validationCheckForSignUp), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(validationCheckForSignUp), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
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
    
    let signUpButton: UIButton = {
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
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already hava an account?  ",
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In",
                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                                                               NSAttributedString.Key.foregroundColor: UIColor(r: 17, g: 154, b: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Life cycle methods need super call of itself.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(plusPhotoButton)
        
        // x, y, w, h
        NSLayoutConstraint.activate([
            plusPhotoButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ])
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                               leading: nil,
                               bottom: nil,
                               trailing: nil,
                               marginTop: 40,
                               marginLeading: 0,
                               marginBottom: 0,
                               marginTrailing: 0,
                               width: 140,
                               height: 140)
        setupInputFields()
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil,
                                     leading: view.safeAreaLayoutGuide.leadingAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                     marginTop: 0,
                                     marginLeading: 0,
                                     marginBottom: 0,
                                     marginTrailing: 0,
                                     width: 0,
                                     height: 50)
    }
    
    // MARK:- Event handling methods
    @objc func validationCheckForSignUp() {
        guard
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        guard
            email.isEmpty == false,
            username.isEmpty == false,
            password.isEmpty == false else {
                signUpButton.isEnabled = false
                signUpButton.backgroundColor = .loginColor
                return
        }
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(r: 17, g: 154, b: 237)
    }
    
    @objc func handlePlusPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        guard
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        
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
            }
            print("\nSuccessfully saved user into database.")
            // Because of new user
            // Refresh UI and dismiss
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {
                return
            }
            mainTabBarController.setupViewControllers()
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }

    // MARK:- Setting up layouts methods
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: nil,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor,
                         marginTop: 20,
                         marginLeading: 40,
                         marginBottom: 0,
                         marginTrailing: 40,
                         width: 0,
                         height: 200)
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
        
        guard let selectedImage = selectedImageFromPicker else {
            return
        }
        
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

