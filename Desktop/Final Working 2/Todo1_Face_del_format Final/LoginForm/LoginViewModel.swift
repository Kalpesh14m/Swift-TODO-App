//
//  LoginViewModel.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 4/14/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class LoginViewModel
{
    var ref:FIRDatabaseReference?
    
    init()
    {
        ref = FIRDatabase.database().reference()
    }
    
    func checkAuthorizedUser(userEmail:String,userPassword:String,completion:@escaping (_ isSucces:Bool) -> Void)
    {
        FIRAuth.auth()?.signIn(withEmail: userEmail, password: userPassword, completion: { (user,error) in
            if error != nil
            {
                print(error!)
                completion(false)
            }
            else
            {
                UserDefaults.standard.set(user?.email, forKey: "CurrentUser")
                
                //store data in UserDefault
                UserDefaults.standard.set(userEmail, forKey: "userEmail")
                UserDefaults.standard.set(userPassword, forKey: "userPassword")
                UserDefaults.standard.synchronize()
                
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                
                currentuser = UserDefaults.standard.value(forKey: "userEmail") as! String
                completion(true)
                
            }})
    }
    func saveFirstLastName(completion:@escaping (_ isSucces:Bool) -> Void)
    {
        // Retrieve the posts and listen for changes
 
        self.ref?.child("Users").child((FIRAuth.auth()!.currentUser?.uid)!).child("Profile").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //Try to convert the value of the data to string
            let post = snapshot.value as? [String:String]
            
            //code to executed when a child is added to the users, take the value from the snapshot and added it to the core data
            if let actualPost = post
            {
                let user_first_name = actualPost["user_first_name"]
                
                let user_last_name = actualPost["user_last_name"]
                
                if user_first_name == nil && user_last_name == nil
                {
                    completion(false)
                }else
                {
                    //save the data to core data
                    UserDefaults.standard.set(user_first_name, forKey: "user_first_name")
                    UserDefaults.standard.set(user_last_name, forKey: "user_last_name")
                    UserDefaults.standard.synchronize()
                    print("Data save succesfully")
                    completion(true)
                }
            }})
    }
}
