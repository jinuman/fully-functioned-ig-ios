//
//  ViewController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 03/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    // MARK:- Screen properties
    let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(checkForm), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(checkForm), for: .editingChanged)
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
        tf.addTarget(self, action: #selector(checkForm), for: .editingChanged)
        return tf
    }()
    
    lazy var signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(r: 149, g: 204, b: 244)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    // MARK:- ViewController life methods
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
                               width: 140,
                               height: 140)
        
        setupInputFields()
    }
    
    // MARK:- Event handling methods
    @objc func checkForm() {
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
                signUpButton.backgroundColor = .signUpButtonBlue
                return
        }
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(r: 17, g: 154, b: 237)
    }
    
    @objc func handleSignUp() {
        guard
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("@@ Failed to create user: ", error.localizedDescription)
                return
            }
            
            print("\n!! Successfully created user: \(result?.user.uid ?? "")\n")
        }
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
                         marginTrailing: 40,
                         height: 200)
    }

}

