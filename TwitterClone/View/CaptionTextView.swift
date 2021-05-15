//
//  CaptionTextView.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 13/05/21.
//

import UIKit

class CaptionTextView: UITextView {
    
    private let placeholder: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = .darkGray
        lb.text = "What`s Happening?"
        return lb
    }()
    
    //  MARK:- LifeCycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        addSubview(placeholder)
        placeholder.anchor(top: topAnchor, left: leftAnchor,
                           paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChanges), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK:- Selectors
    
    @objc func handleTextInputChanges() {
        placeholder.isHidden = !text.isEmpty
    }
}
