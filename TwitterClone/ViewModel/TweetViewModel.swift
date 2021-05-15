//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 15/05/21.
//

import UIKit

struct TweetViewModel {
    
    let tweet: Tweet
    let user: User
    
    var profileImageURl: URL? {
        return tweet.user.profileImageUrl
    }
    
    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        
        return formatter.string(from: tweet.timeStamp, to: now) ?? ""
    }
    
    var userInfoText: NSAttributedString {
        
        let title = NSMutableAttributedString(string: user.fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.userName)", attributes: [.font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: ". \(timeStamp)", attributes: [.font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    init(tweet: Tweet) {
        
        self.tweet = tweet
        self.user = tweet.user
    }
}
