//
//  ProfileViewController.swift
//  SocialTest
//
//  Created by ThinkDWM on 9/2/16.
//  Copyright © 2016 ThinkDWM. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class ProfileViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var logoutButton: UIButton!
    
    var profileName: String?
    
    var profileImageURL: NSURL?
    
    let imageLoader = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    
    func logoutButtonAction(sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController {
            FBSDKLoginManager().logOut()
            vc.modalPresentationStyle = .OverCurrentContext
            vc.modalTransitionStyle = .CrossDissolve
            self.presentViewController(vc, animated: true) { }
        }
    }
    
    func getCurrentProfile(completion: (result: AnyObject, error: NSError?) -> Void) {
        
        self.imageLoader.center.x = self.view.center.x
        self.imageLoader.center.y = self.profileImageView.center.y
        self.imageLoader.startAnimating()
        self.view.addSubview(self.imageLoader)
        
        let currentProfile = FBSDKProfile.currentProfile()
        self.profileImageURL = currentProfile.imageURLForPictureMode(.Normal, size: CGSize(width: 1080, height: 1080))
        
        let request = FBSDKGraphRequest(graphPath: "me",
                                        parameters: ["fields": "id, name, first_name, last_name, email, gender, link"],
                                        tokenString: FBSDKAccessToken.currentAccessToken().tokenString,
                                        version: nil,
                                        HTTPMethod: "GET")
        
        request.startWithCompletionHandler { (connection, result, error) in
            if error == nil {
                completion(result: result, error: error)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
        
        self.getCurrentProfile { (result, error) in
            if error == nil {
                self.nameLabel.text = result["name"] as? String
                
                self.profileImageView.kf_setImageWithURL(self.profileImageURL, completionHandler: { (image, error, cacheType, imageURL) in
                    if error == nil {
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.imageLoader.removeFromSuperview()
                        })
                    }
                })
                
            }
        }
        
        self.logoutButton.addTarget(self, action: #selector(self.logoutButtonAction(_:)), forControlEvents: .TouchUpInside)
        
    }
    
}