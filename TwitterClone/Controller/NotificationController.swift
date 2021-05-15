//
//  NotificationController.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 02/05/21.
//

import UIKit

class NotificationController: UIViewController {
    
    //  MARK:- Properties

    
    //  MARK:- LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

    }
    
    //  MARK:- Helper
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notification"
    }
    

}
