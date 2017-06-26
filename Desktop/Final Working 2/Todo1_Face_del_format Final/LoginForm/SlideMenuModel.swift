//
//  SlideMenuModel.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 4/25/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class SlideViewModel
{
    var ref:FIRDatabaseReference?
    
    init()
    {
        ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()!.currentUser!.uid))
    }
    
    func saveImageData(completion:@escaping (_ result:Bool)->Void)
    {
        // Retrieve the posts and listen for changes
        self.ref?.child("Profile").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //Try to convert the value of the data to string
            let post = snapshot.value as? [String:String]
            
            //code to executed when a child is added to the users, take the value from the snapshot and added it to the core data
            if let actualPost = post
            {
                let user_profile_imgurl = actualPost["user_profile_imgurl"]
                print("In profile state")
                let user_background_imgurl = actualPost["user_background_imgurl"]
                print("In backprofile state")
                
                if user_profile_imgurl == nil && user_background_imgurl == nil
                {
                    completion(false)
                }else
                {
                    //save the data to core data
                    UserDefaults.standard.set(user_profile_imgurl, forKey: "user_profile_imgurl")
                    UserDefaults.standard.set(user_background_imgurl, forKey: "user_background_imgurl")
                    UserDefaults.standard.synchronize()
                    print("Data save succesfully")
                    completion(true)
                }
            }})
    }
    
    func logout(completion:@escaping (_ result:Bool)->Void)
    {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.removeObject(forKey: "user_first_name")
        UserDefaults.standard.removeObject(forKey: "user_last_name")
        UserDefaults.standard.set(false, forKey: "isUserProfileSet")
        UserDefaults.standard.set(false, forKey: "isUserBackProfileSet")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "user_profile_imgurl")
        UserDefaults.standard.removeObject(forKey: "user_background_imgurl")
        UserDefaults.standard.synchronize()
        
        //remove core data and array data
        currentUserData.removeAll()
        myData.removeAll()
        myArchData.removeAll()
        DataBaseModels.removeCoreData()
        
        completion(true)
    }
}
