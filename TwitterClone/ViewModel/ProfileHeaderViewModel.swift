//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 15/05/21.
//

import UIKit
import Firebase

enum ProfileFilterOption: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    var followrsString: NSAttributedString? {
        return attributedText(withValue: 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: 0, text: "following")
    }
    
    var actionButtontitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            return "Follow"
        }
    }
    
    init(user: User) {
        self.user = user
    }
    
    private func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedString.append(NSAttributedString(string: "\(text)", attributes: [.font: UIFont.systemFont(ofSize: 14),
                                .foregroundColor: UIColor.lightGray]))
        
        return attributedString
        
    }
}


