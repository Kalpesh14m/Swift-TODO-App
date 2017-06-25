//  DataProfile.swift
//Purpose:
    //1.Used for Create User Profile Dictionary.

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
