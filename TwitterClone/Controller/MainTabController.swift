//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 02/05/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MainTabController: UITabBarController {
    
    //  MARK:- Properties
    
    var user: User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else{return}
            guard let feed = nav.viewControllers.first as? FeedController else{return}
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()
    

    //  MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
//                logUserOut()

        authenticateUSerAndConfigureUI()

    }
    
    //  MARK:- API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid ) { user in
            self.user = user        }
    }
    
    func authenticateUSerAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            debugPrint("DEBUG: User is NOT logged in..")
            
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            debugPrint("DEBUG: User is  logged in..")
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //  MARK:- Selectors
    
    @objc
    func handleActionButtonTapped() {
        guard let user = user else{return}
        let controller = UploadTweetController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //  MARK:- Helpers
    
    func configureUI(){
        view.addSubview(actionButton)
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers() {
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feedNav = templeteNavigationComtroller(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreViewController()
        let exploreNav = templeteNavigationComtroller(image: UIImage(named: "search_unselected"), rootViewController: explore)


        let notifications = NotificationController()
        let notificationsNav = templeteNavigationComtroller(image: UIImage(named: "like_unselected"), rootViewController: notifications)


        let conversations = ConversationsController()
        let conversationsNav = templeteNavigationComtroller(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)

        
        viewControllers = [feedNav, exploreNav, notificationsNav, conversationsNav]
    }
    
    func templeteNavigationComtroller(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }

}
