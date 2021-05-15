//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 13/05/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    //  MARK:- Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    private let plusLogoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilites().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilites().inputContainerView(withImage: image, textField: passwordTextField)
        
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilites().testField(withPlaceHolder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilites().testField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilites().inputContainerView(withImage: image, textField: fullNameTextField)
        return view
    }()
    
    private lazy var userNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilites().inputContainerView(withImage: image, textField: userNameTextField)
        
        return view
    }()
    
    private let fullNameTextField: UITextField = {
        let tf = Utilites().testField(withPlaceHolder: "Full Name")
        return tf
    }()
    
    private let userNameTextField: UITextField = {
        let tf = Utilites().testField(withPlaceHolder: "Username")
        return tf
    }()
    
    private let singUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton =  {
        let button = Utilites().attributedButton("Already have an account?", " Login Up")
        button.addTarget(self, action: #selector(handleShowLoginUp), for: .touchUpInside)
        return button
    }()
    
    //  MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    //  MARK:- Selectors
    
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleRegister() {
        
        guard let profileImage = profileImage else {
            debugPrint("DEBUG: please select a profile image..")
            return
        }
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        guard let fullName = fullNameTextField.text else{return}
        guard let userName = userNameTextField.text?.lowercased() else{return}
        

        let credentials = AuthCredentials(email: email, password: password, fullName: fullName, userName: userName, profileImage: profileImage)
        
        AuthServies.shared.registerUser(credentials: credentials) { error, ref in
            debugPrint("DEBUG: Sign up Successfully..")
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else{return}
            
            guard let tab = window.rootViewController as? MainTabController else{return}
            
            tab.authenticateUSerAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }

        
    }
    
    
    @objc func handleShowLoginUp() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    //  MARK:- Helpers
    
    func configure() {
        view.backgroundColor = .twitterBlue
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusLogoButton)
        plusLogoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusLogoButton.setDimensions(width: 130, height: 130)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView, fullNameContainerView, userNameContainerView, singUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusLogoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft:  40, paddingRight: 40)
        
    }
}

//  MARK:- UIIMagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[.editedImage] as? UIImage else{return}
        self.profileImage = profileImage
        plusLogoButton.layer.cornerRadius = 128/2
        plusLogoButton.layer.masksToBounds = true
        plusLogoButton.imageView?.contentMode = .scaleAspectFit
        plusLogoButton.imageView?.clipsToBounds = true
        plusLogoButton.layer.borderColor = UIColor.white.cgColor
        plusLogoButton.layer.borderWidth = 3
        
        self.plusLogoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
