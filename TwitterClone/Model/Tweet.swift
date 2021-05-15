//
//  Tweet.swift
//  TwitterClone
//
//  Created by Sourabh Jain on 14/05/21.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    let uid: String
    let likes: Int
    var timeStamp: Date!
    let retweetCount: Int
    let user: User
    
    init(user: User, tweetID: String, dictonary: [String: Any]) {
        self.user = user
        
        self.tweetID = tweetID
        
        self.caption = dictonary["caption"] as? String ?? ""
        self.uid = dictonary["uid"] as? String ?? ""
        self.likes = dictonary["likes"] as? Int ?? 0
        self.retweetCount = dictonary["retweets"] as? Int ?? 0
        
        if let timeStamp = dictonary["timestamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
        
    }
}
