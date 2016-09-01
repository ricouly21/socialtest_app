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


class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    
    var profileName = String()
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        self.performSegueWithIdentifier("returnToLogin", sender: self)
        
//        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return false
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ViewController {
            vc.loginButton.hidden = false
            vc.loaderView.removeFromSuperview()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = "You are logged in as \(self.profileName)!"
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        
    }
    
}