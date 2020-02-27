//
//  CommentInputAccessoryView.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 30/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate: class {
    func didSend(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter comment.."
        label.textColor = .lightGray
        return label
    }()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(self.handleSend), for: .touchUpInside)
        
        return button
    }()
    
    private let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        return view
    }()
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK:- Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        autoresizingMask = .flexibleHeight
        
        [commentTextView, sendButton, lineSeparatorView].forEach {
            addSubview($0)
        }
        
        let guide = safeAreaLayoutGuide
        commentTextView.anchor(top: topAnchor,
                                leading: leadingAnchor,
                                bottom: guide.bottomAnchor,
                                trailing: sendButton.leadingAnchor,
                                padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0))
        
        sendButton.anchor(top: topAnchor,
                          leading: nil,
                          bottom: guide.bottomAnchor,
                          trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12),
                          size: CGSize(width: 50, height: 0))
        
        lineSeparatorView.anchor(top: topAnchor,
                                 leading: leadingAnchor,
                                 bottom: nil,
                                 trailing: trailingAnchor,
                                 size: CGSize(width: 0, height: 0.5))
        
        setupPlaceholderInsideCommentTextView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupPlaceholderInsideCommentTextView() {
        commentTextView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: commentTextView.topAnchor,
                                leading: commentTextView.leadingAnchor,
                                bottom: commentTextView.bottomAnchor,
                                trailing: commentTextView.trailingAnchor,
                                padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0))
    }
    
    @objc fileprivate func handleSend() {
        guard let comment = commentTextView.text else { return }
        delegate?.didSend(for: comment)
    }
    
    @objc fileprivate func handleTextChange() {
        placeholderLabel.isHidden = !commentTextView.text.isEmpty
    }
    
    func clearCommentTextView() {
        self.commentTextView.text = nil
        self.placeholderLabel.isHidden = false
    }
}
