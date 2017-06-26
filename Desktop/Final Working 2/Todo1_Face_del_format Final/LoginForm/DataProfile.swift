//
//  DataProfile.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 4/6/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation
import UIKit

class UserPostModel
{
    static func addTask(title:String,note:String,key:String) -> [String:String]
    {
        let dict = ["title":title, "note":note, "key":key]
        return dict
    }
    
    static func addProfile(firstName:String,lastName:String,email:String,password:String,mobile:String) ->[String:String]
    {
        let dict =
        [
           "user_first_name":firstName,
            "user_last_name":lastName,
            "Email": email,
            "Password": password,
            "Mobile": mobile,
        ]
        return dict
    }
}
