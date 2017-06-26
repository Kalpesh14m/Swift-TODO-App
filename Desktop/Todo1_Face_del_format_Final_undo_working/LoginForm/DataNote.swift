//
//  DataNote.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 4/6/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

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
