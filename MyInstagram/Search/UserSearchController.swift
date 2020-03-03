//
//  UserSearchController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 23/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController {
    
    private let cellId = "cellId"
    private var users = [User]()
    private var filteredUsers = [User]()
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        let textFieldInsideSearchBar = sb.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        sb.delegate = self
        return sb
    }()
    
    // MARK: - Initializing
    
    deinit {
        print("UserSearchController \(#function)")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
        
        self.navigationController?.navigationBar.addSubview(searchBar)
        
        let navBar = navigationController?.navigationBar
        self.searchBar.anchor(
            top: navBar?.topAnchor,
            leading: navBar?.leadingAnchor,
            bottom: navBar?.bottomAnchor,
            trailing: navBar?.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        )
        
        self.collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.keyboardDismissMode = .onDrag
        
        self.fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    // MARK: - Methods
    
    private func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard
                let self = self,
                let dictionaries = snapshot.value as? [String : Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                
                if key == Auth.auth().currentUser?.uid {
                    print("Found myself, omit from list")
                    return
                }
                
                guard let userDictionary = value as? [String : Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            
            self.users.sort(by: { (u0, u1) -> Bool in
                return u0.username.lowercased().compare(u1.username.lowercased()) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collectionView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension UserSearchController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserSearchCell else {
            fatalError("Failed cast to UserSearchCell")
        }
        cell.user = filteredUsers[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.safeAreaLayoutGuide.layoutFrame.width
        return CGSize(width: width, height: 66) // image width + padding * 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let user = filteredUsers[indexPath.item]
        
        let userProfileController = MyProfileViewController()
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
}

// MARK:- Regarding SearchBar delegate
extension UserSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                let searchText = searchText.lowercased()
                return user.username.lowercased().contains(searchText)
            }
        }
        
        collectionView.reloadData()
    }
}
