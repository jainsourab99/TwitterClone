//
//  UserService.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 13/05/21.
//

import Firebase
import FirebaseAuth
import FirebaseDatabase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            debugPrint("DEBUG: Snapshot \(snapshot)")
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else{return}
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
            
            debugPrint("DEBUG: FullName is \(user.fullName)")
            debugPrint("DEBUG: UserName is \(user.userName)")

        }
    }
}
