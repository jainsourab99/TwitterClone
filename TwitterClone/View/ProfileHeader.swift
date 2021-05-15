//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 15/05/21.
//

import UIKit

protocol ProfileHeaderdelegate: class {
    func handleDismissal()
}

class ProfileHeader: UICollectionReusableView {
    
    //  MARK:- Properties
    
    weak var delegate: ProfileHeaderdelegate?
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private let filterBar = ProfileFillterView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor,
                          paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        return view
    }()
    
    private lazy var backButton: UIButton = {
       let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4

        return iv
    }()
    
    private lazy var editProfileButton: UIButton = {
       let button = UIButton()
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.text = "Sourabh"
        return lb
    }()
    
    private let userNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = .lightGray
        lb.text = "Jain"
        return lb
    }()
    
    private let biolabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.numberOfLines = 3
        lb.text = "What`s Happening?"
        return lb
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.addGestureRecognizer(followingTap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.addGestureRecognizer(followingTap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    
    //  MARK:- LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor,
                                paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: containerView.bottomAnchor,
                                 right: rightAnchor, paddingTop: 12,
                                 paddingRight: 12)
        editProfileButton.setDimensions(width: 100, height: 36)
        editProfileButton.layer.cornerRadius = 36 / 2
        
        let userDetailsStack = UIStackView(arrangedSubviews: [fullNameLabel,
                                                                userNameLabel,
                                                                biolabel])
        userDetailsStack.axis = .vertical
        userDetailsStack.distribution = .fillProportionally
        userDetailsStack.spacing = 4
        
        addSubview(userDetailsStack)
        userDetailsStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor,
                                right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(top: userDetailsStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft:  12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        addSubview(underLineView)
        underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK:- Selectors
    
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    
    @objc func handleEditProfileFollow() {
        
    }
    
    @objc func handleFollowersTapped() {
        
    }
    
    @objc func handleFollowingTapped() {
        
    }
    
    //  MARK:- configure
    
    func configure() {
        guard let user = user else { return }
        
        let viewModel = ProfileHeaderViewModel(user: user)
        
        editProfileButton.setTitle(viewModel.actionButtontitle, for: .normal)
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        followersLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followrsString
    }
}

//  MARK:- ProfileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFillterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }
        
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underLineView.frame.origin.x = xPosition
        }
    }
}
