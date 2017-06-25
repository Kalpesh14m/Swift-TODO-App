//  DataNote.swift
//Purpose:
    //1.Used for Create Notes Dictionary.

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserDataModel
{
    static func addTask(title:String,notes:String,reminder:String) -> [String:String]
        {
            let dict = ["title":title,"note":notes,"reminder":reminder]
            return dict
        }
}
