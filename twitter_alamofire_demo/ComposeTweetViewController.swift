//
//  ComposeTweetViewController.swift
//  twitter_alamofire_demo
//
//  Created by Anurag Kumar Yadav on 3/24/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

protocol ComposeViewControllerDelegate :class {
    func did(post: Tweet)
}
class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetText: RSKPlaceholderTextView!
    
    @IBOutlet weak var characterCountLabel: UILabel!
    weak var delegate: ComposeViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetText.delegate = self
        tweetText.placeholder = "Write a tweet!"
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapTweet(_ sender: Any) {
        APIManager.shared.composeTweet(with: tweetText.text) { (tweet: Tweet?, error: Error?) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
            }
        }
    }
    
    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("Insde the Delegate function.")
        let characterLimit = 140
        let newText = NSString(string: tweetText.text!).replacingCharacters(in: range, with: text)
        characterCountLabel.text = String(characterLimit - newText.count)
        return newText.count < characterLimit
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
