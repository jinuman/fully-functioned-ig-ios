//
//  UIKit+MyInstagram.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 03/03/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

extension NSObjectProtocol {
    static var className: String {
        return "\(self)"
    }
    var className: String {
        return Self.className
    }
}

extension UIViewController {
    func deinitLog(objectName: String? = nil) {
        #if DEBUG
        print("\n===============================================")
        if let objectName = objectName {
            print("♻️ \(objectName) deinit ♻️")
        } else {
            print("♻️ \(self.className) deinit ♻️")
        }
        print("===============================================\n")
        #endif
    }
    
    static func toNavigationController(isHiddenBar: Bool = false) -> UINavigationController {
        let `self` = self.init()
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.isNavigationBarHidden = isHiddenBar
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        return navigationController
    }
}

extension UICollectionView {
    
    func registerNibName(_ name: String) {
        register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(
        cellType: T.Type,
        for indexPath: IndexPath)
        -> T
    {
        return dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as? T ?? T()
    }
    
    /**
     다수의 UICollectionViewCell들을 동시에 register 할 수 있도록 도와준다.
     
     - Parameters:
     - cellTypes: 다수의 UICollectionViewCell.Type들로 이루어진 Array
     */
    func register<T: UICollectionViewCell>(_ cellTypes: [T.Type]) {
        for cellType in cellTypes {
            self.register(cellType, forCellWithReuseIdentifier: "\(cellType.self)")
        }
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static var loginColor: UIColor {
        return .init(r: 149, g: 204, b: 244)
    }
    
    static let enabledButtonColor = UIColor(r: 17, g: 154, b: 237)
    
    static let disabledButtonColor = UIColor(white: 0, alpha: 0.2)
}

extension UIView {
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top).isActive = true
        
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left).isActive = true
        
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom).isActive = true
        
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right).isActive = true
        
        widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: superview.heightAnchor).isActive = true
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func centerXInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    }
    
    func centerYInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
    
    func constrainWidth(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func constrainHeight(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
}

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}



