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
    
    var user = User()
    
    var userData = [String: AnyObject]()
    
    
    
    
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
                    
                    let profileImageURL = profile.imageURLForPictureMode(.Normal, size: CGSize(width: 1080, height: 1080))
                    
                    let request = FBSDKGraphRequest(graphPath: "me",
                        parameters: ["fields": "id, name, first_name, last_name, email, gender, link"],
                        tokenString: FBSDKAccessToken.currentAccessToken().tokenString,
                        version: nil,
                        HTTPMethod: "GET")
                    
                    request.startWithCompletionHandler { (connection, result, error) in
                        if error == nil {
                            
                            self.userData = [
                                "id": "",
                                "social_id": profile.userID,
                                "name": profile.name,
                                "last_name": profile.lastName,
                                "first_name": profile.firstName,
                                "gender": result["gender"] as! String,
                                "email": result["email"] as! String,
                                "profile_image": profileImageURL.absoluteString,
                                "social_media": "facebook",
                            ]
                            
                            self.user = User(data: self.userData)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.performSegueWithIdentifier("toProfileViewController", sender: "facebook")
                            })
                        }
                    }
                    
                }
                
                self.fbLoginButton.hidden = false
                
            }
        }
        
    }
    
    // Google Sign-In delegates
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true) { }
    }
    
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true) { }
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error == nil {
            if let profile: GIDProfileData = user.profile {
                self.userData = [
                    "id": "",
                    "social_id": user.userID,
                    "name": profile.name,
                    "last_name": profile.familyName,
                    "first_name": profile.givenName,
                    "email": profile.email,
                    "gender": "",
                    "profile_image": profile.imageURLWithDimension(1080).absoluteString,
                    "social_media": "google",
                ]
                
                self.user = User(data: self.userData)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("toProfileViewController", sender: "google")
                })
                
            }
        } else {
            print(error)
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ProfileViewController {
            vc.user = self.user
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBSDKLoginManager().logOut()
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

