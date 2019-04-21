//
//  SignInController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 04/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Firebase

class SignInController: UIViewController {
    
    // MARK:- Screen properties
    private let logoContainerView: UIView = {
        let containerView = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFill
        
        containerView.addSubview(logoImageView)
        
        logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 10).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.backgroundColor = UIColor(r: 0, g: 120, b: 175)
        return containerView
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(validationCheckForSignIn), for: .editingChanged)
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
        tf.addTarget(self, action: #selector(validationCheckForSignIn), for: .editingChanged)
        return tf
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .loginColor
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't hava an account?  ",
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up",
                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                                                               NSAttributedString.Key.foregroundColor: UIColor(r: 17, g: 154, b: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleDontHaveAccount), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setupSubviewsForSignIn()
    }
    
    // MARK:- Setup screen constraints method
    fileprivate func setupSubviewsForSignIn() {
        [logoContainerView, dontHaveAccountButton].forEach {
            view.addSubview($0)
        }
        let guide = view.safeAreaLayoutGuide
        
        logoContainerView.anchor(top: view.topAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: nil,
                                 trailing: view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                 size: CGSize(width: 0, height: 150))
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: logoContainerView.bottomAnchor,
                         leading: guide.leadingAnchor,
                         bottom: nil,
                         trailing: guide.trailingAnchor,
                         padding: UIEdgeInsets(top: 40, left: 40, bottom: 0, right: 40),
                         size: CGSize(width: 0, height: 140))
        
        dontHaveAccountButton.anchor(top: nil,
                                     leading: guide.leadingAnchor,
                                     bottom: guide.bottomAnchor,
                                     trailing: guide.trailingAnchor,
                                     size: CGSize(width: 0, height: 50))
    }
    
    // MARK:- Handling methods
    @objc func handleDontHaveAccount() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    @objc func validationCheckForSignIn() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        guard
            email.isEmpty == false,
            password.isEmpty == false else {
                signInButton.isEnabled = false
                signInButton.backgroundColor = .loginColor
                return
        }
        signInButton.isEnabled = true
        signInButton.backgroundColor = UIColor(r: 17, g: 154, b: 237)
    }
    
    @objc func handleSignIn() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                print("Sign In: Form is not proper.")
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                print("Failed to sign in: \(error.localizedDescription)")
                return
            }
            print("\nSuccessfully sign in!: \(email), \(password)")
            
            // Refresh UI by logged in user and dismiss
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {
                return
            }
            mainTabBarController.setupViewControllers()
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
