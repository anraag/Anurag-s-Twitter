//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Anurag Kumar Yadav on 3/24/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetImage.af_setImage(withURL: tweet.user.profileImageURL!)
        tweetContentLabel.text = tweet.text
        likeCountLabel.text = String(tweet.favoriteCount!)
        dateLabel.text = tweet.createdAtString.shortTimeAgoSinceNow
        retweetCountLabel.text = String(tweet.retweetCount)
        screenNameLabel.text = String(describing: tweet.user.dictionary!["screen_name"]!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        tweet.retweet()
        if (tweet.retweeted){
            retweetCountLabel.text = String(Int(retweetCountLabel.text!)! + 1)
            
        }else{
            retweetCountLabel.text = String(Int(retweetCountLabel.text!)! - 1)
        }
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        tweet.favorite()
        if (tweet.favorited!){
            likeCountLabel.text = String(Int(likeCountLabel.text!)! + 1)
        }else{
            likeCountLabel.text = String(Int(likeCountLabel.text!)! - 1)
        }
        
    }
    @IBAction func didTapBack(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("returnHome"), object: nil)
    }
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
