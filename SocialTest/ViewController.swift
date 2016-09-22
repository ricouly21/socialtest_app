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
import TwitterKit
import Kingfisher


class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBAction func returnToLogin(segue: UIStoryboardSegue) {}
    @IBOutlet var fbLoginButton: FBSDKLoginButton!
    @IBOutlet var twtrLoginButton: TWTRLogInButton!
    @IBOutlet var gidSignInButton: GIDSignInButton!
    
    
    // FBSDK login button delegates

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil {
            self.fbLoginButton.hidden = true
            
            FBSDKProfile.loadCurrentProfileWithCompletion { (profile, error) in
                
                if error == nil && profile != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("toProfileViewController", sender: self)
                    })
                    
                }
                
                self.fbLoginButton.hidden = false
                
            }
        }
        
    }
    
    // Google Sign-In delegates
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true) { }
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error == nil {
            if let profile: GIDProfileData = user.profile {
                print(profile.email)
                print(profile.familyName)
                print(profile.givenName)
                print(profile.name)
                print(profile.imageURLWithDimension(1080))
            }
        } else {
            print(error)
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().signOut()
        
        self.fbLoginButton.setAttributedTitle(NSAttributedString(string: "Facebook"), forState: .Normal)
        self.fbLoginButton.delegate = self
        self.fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        self.twtrLoginButton.enabled = false
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        self.gidSignInButton.style = .Wide
        
    }

}

