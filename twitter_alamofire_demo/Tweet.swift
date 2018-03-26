//
//  Tweet.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class Tweet {
    
    // MARK: Properties
    var id: Int64 // For favoriting, retweeting & replying
    var text: String // Text content of tweet
    var favoriteCount: Int? // Update favorite count label
    var favorited: Bool? // Configure favorite button
    var retweetCount: Int // Update favorite count label
    var retweeted: Bool // Configure retweet button
    var user: User // Contains name, screenname, etc. of tweet author
    var createdAtString: Date // Display date
    
    // For Retweets
    var retweetedByUser: User?  // user who retweeted if tweet is retweet
    
    // MARK: - Create initializer with dictionary
    init(dictionary: [String: Any]) {
        // Is this a re-tweet?
        
        id = dictionary["id"] as! Int64
        text = dictionary["text"] as! String
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweetCount = dictionary["retweet_count"] as! Int
        retweeted = dictionary["retweeted"] as! Bool
        
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        createdAtString = formatter.date(from: createdAtOriginalString)!
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        // Convert Date to String
        // createdAtString = formatter.string(from: date)
    }
    
    static func tweets(with array: [[String: Any]]) -> [Tweet] {
        var tweets: [Tweet] = []
        for tweetDictionary in array {
            let tweet = Tweet(dictionary: tweetDictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    func PrintDetails(){
        print("ID:  \(self.id)")
        print("Tweet Data: \(self.text)")
        print("Favorite Count: \(self.favoriteCount!)")
        print("Favorited: \(self.favorited!)")
        print("Retweet Count: \(self.favoriteCount!)")
        print("Retweeted: \(self.favorited!)")
    }
    
    func favorite(){
        if self.favorited!{
            self.favorited = false
            self.favoriteCount! -= 1
            APIManager.shared.unFavorite(self) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            }
        } else{
            self.favorited = true
            self.favoriteCount! += 1
            APIManager.shared.favorite(self) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error Unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        }
    }
    
    func retweet(){
        if self.retweeted{
            self.retweeted = false
            self.retweetCount -= 1
            APIManager.shared.unReTweet(self) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error Unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully UnRetweeted the following Tweet: \n\(tweet.text)")
                }
            }
        } else{
            self.retweeted = true
            self.retweetCount += 1
            APIManager.shared.reTweet(self) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error Retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully Retweeted the following Tweet: \n\(tweet.text)")
                }
            }
        }
    }
}

