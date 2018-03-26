//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import DateToolsSwift
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            profileImage.af_setImage(withURL: tweet.user.profileImageURL!)
            tweetTextLabel.text = tweet.text
            likeLabel.text = String(tweet.favoriteCount!)
            dateLabel.text = tweet.createdAtString.shortTimeAgoSinceNow
            retweetLabel.text = String(tweet.retweetCount)
            screenNameLabel.text = String(describing: tweet.user.dictionary!["screen_name"]!)
        }
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        // Check if it's already a favorite.
        print(tweet.favorited!)
        if tweet.favorited!{
            tweet.favorited = false
            tweet.favoriteCount! -= 1
            APIManager.shared.unFavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Favorited: \n\(tweet.text)")
                }
            }
        } else{
            tweet.favorited = true
            tweet.favoriteCount! += 1
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error Unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Unfavorited: \n\(tweet.text)")
                }
            }
        }
        refreshData()
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if tweet.retweeted{
            tweet.retweeted = false
            tweet.retweetCount -= 1
            APIManager.shared.unReTweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error Unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("UnRetweeted: \n\(tweet.text)")
                }
            }
        } else{
            tweet.retweeted = true
            tweet.retweetCount += 1
            APIManager.shared.reTweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error Retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Retweeted: \n\(tweet.text)")
                }
            }
        }
        refreshData()
    }
    
    
    func refreshData(){
        let indexPathToRefresh = IndexPath(row: 0, section: 0)
        NotificationCenter.default.post(name: NSNotification.Name("needToRefresh"), object: nil,userInfo: ["IndexPath": indexPathToRefresh])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
