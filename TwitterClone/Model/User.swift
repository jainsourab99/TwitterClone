//
//  User.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 13/05/21.
//

import Firebase
import FirebaseAuth

struct User {
    let fullName: String
    let email: String
    let userName: String
    var profileImageUrl: URL?
    let uid: String
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String,dictionary: [String: AnyObject]) {
        self.uid = uid
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        if let profileImageUrl = dictionary["profileImageURL"] as? String {
            self.profileImageUrl = URL(string: profileImageUrl)
        }

    }
}
