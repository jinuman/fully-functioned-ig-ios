//
//  SignInController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 04/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    
    // MARK:- Screen properties
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account?\tSign Up.", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil,
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
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
}
