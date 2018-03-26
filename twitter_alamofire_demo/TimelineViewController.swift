//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate  {
    
    
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func didTapPost(_ sender: Any) {
        self.performSegue(withIdentifier: "composeTweet", sender: self)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl){
        print("Called Refresh Control.")
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting timeline: " + error.localizedDescription)
            }
        }
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting timeline: " + error.localizedDescription)
            }
        }
        
        APIManager.shared.getUserInformation(username: "anuragkyadav61") { (userInfo, error) in
            if userInfo != nil {
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        // Print the contents of all the tweets.
        for a in self.tweets{
            a.PrintDetails()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableViewCell(_:)), name: NSNotification.Name(rawValue: "needToRefresh"), object: nil)
    }
    
    
    @objc func refreshTableViewCell(_ notification : NSNotification ){
        print("Refresh Notification Received.")
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func did(post: Tweet) {
        print("Tweet Posted in the Timeline.")
        NotificationCenter.default.post(name: NSNotification.Name("returnHome"), object: nil)
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                let tweetTapped = tweets[indexPath.row]
                let tweetDetailViewController = (segue.destination as! UINavigationController).topViewController as! TweetDetailViewController
                tweetDetailViewController.tweet = tweetTapped
            }
        }else if (segue.identifier == "composeTweet"){
            print("Here")
            let destinationVC = segue.destination as! ComposeTweetViewController
            destinationVC.delegate = self
        }
     
     
     }
    
    
}
