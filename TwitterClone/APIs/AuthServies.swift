//
//  AuthServies.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 13/05/21.
//
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}

class AuthServies {
    static let shared = AuthServies()
    
    func logUserIn(withEmail: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: completion)
    }
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        let email = credentials.email
        let password = credentials.password
        let userName = credentials.userName
        let fullName = credentials.fullName


        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else{return}
        let fileName = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(fileName)
        storageRef.putData(imageData, metadata: nil) { Result, error in
            storageRef.downloadURL { url, error in
                guard let profileImageURL = url?.absoluteString else {return}
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        debugPrint("DEBUG: ERROR is \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else{return}
                    
                    let values = ["email": email,
                                  "userName": userName,
                                  "fullName": fullName,
                                  "profileImageURL": profileImageURL]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}




