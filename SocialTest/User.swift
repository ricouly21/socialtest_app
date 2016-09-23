//
//  User.swift
//  SocialTest
//
//  Created by ThinkDWM on 9/23/16.
//  Copyright © 2016 ThinkDWM. All rights reserved.
//

import Foundation
import UIKit


class User {
    
    var id: String?
    var socialID: String?
    var socialMedia: String?
    var fullName: String?
    var firstName: String?
    var lastName: String?
    var gender: String?
    var email: String?
    var profileImage: String?
    
    init(data: AnyObject) {
        self.id = data["id"] as? String
        self.socialID = data["social_id"] as? String
        self.socialMedia = data["social_media"] as? String
        self.fullName = data["name"] as? String
        self.firstName = data["first_name"] as? String
        self.lastName = data["last_name"] as? String
        self.gender = data["gender"] as? String
        self.email = data["email"] as? String
        self.profileImage = data["profile_image"] as? String
    }

    init() { }
    
}