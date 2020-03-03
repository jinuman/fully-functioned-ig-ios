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
    
    private lazy var guide = self.safeAreaLayoutGuide
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter comment.."
        label.textColor = .lightGray
        return label
    }()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
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
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK:- Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initializeLayout()
        
        self.commentTextView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
            $0.bottom.equalTo(self.guide).inset(8)
            $0.trailing.equalTo(self.sendButton.snp.leading)
        }
        
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
    
    private func initializeLayout() {
        self.backgroundColor = .white
        self.autoresizingMask = .flexibleHeight
        
        self.addSubviews([
            self.commentTextView,
            self.sendButton,
            self.lineSeparatorView
        ])
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
