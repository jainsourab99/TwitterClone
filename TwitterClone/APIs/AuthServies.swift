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
    func registerUser(credential: AuthCredential, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = credential.email
        let password = credential.password
        let userName = credential.userName
        let fullName = credential.fullName
        guard let imageData = credential.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        
        let storageRef = STOGARE_PROFILE_REF.child(fileName)
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": email,
                                  "userName": userName,
                                  "fullName": fullName,
                                  "profileImageURL": profileImageURL]
                    
                    REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                        print("updateChildValues")
                        completion(error, ref)
                    }
                }
            }
        }
    }

}




