//
//  ViewController.swift
//  SocialTest
//
//  Created by ThinkDWM on 7/29/16.
//  Copyright © 2016 ThinkDWM. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBAction func returnToLogin(segue: UIStoryboardSegue) {}
    
    let loginButton = FBSDKLoginButton()
    
    let loaderView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    var profileName = String()
    
    
    // FBSDK login button delegates

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        self.loginButton.hidden = true
        self.view.addSubview(self.loaderView)
        
        FBSDKProfile.loadCurrentProfileWithCompletion { (profile, error) in
            
            if profile != nil {
                
                self.profileName = profile.name
                
                self.performSegueWithIdentifier("toProfileViewController", sender: self)
                
            } else {
                dispatch_async(dispatch_get_main_queue(), { 
                    self.loaderView.removeFromSuperview()
                    self.loginButton.hidden = false
                })
            }
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ProfileViewController {
            vc.profileName = self.profileName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loaderView.center = self.view.center
        self.loaderView.startAnimating()
        
        self.loginButton.center = self.view.center
        self.view.addSubview(self.loginButton)
        
        
        self.loginButton.delegate = self
        self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
    }


}

