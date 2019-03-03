//
//  ViewController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 03/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- Screen properties
    let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
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
        return tf
    }()
    
    let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(r: 149, g: 204, b: 244)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return btn
    }()
    
    // MARK:- ViewController life methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(plusPhotoButton)
        
        // x, y, w, h
        NSLayoutConstraint.activate([
            plusPhotoButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            plusPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            plusPhotoButton.widthAnchor.constraint(equalToConstant: 140),
            plusPhotoButton.heightAnchor.constraint(equalToConstant: 140)
            ])
        
        setupInputFields()
    }

    // MARK:- Setting up layouts methods
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        // x, y, w, h
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40).isActive = true
        stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200)
    }

}

