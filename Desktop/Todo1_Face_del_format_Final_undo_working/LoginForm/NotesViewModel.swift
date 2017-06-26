//
//  NotesViewModel.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 4/25/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class NotesViewModel
{
    var ref:FIRDatabaseReference?
    
    init()
    {
        ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()!.currentUser!.uid)).child("Data")
    }
    
    //This method will call when you press notes back button.
    func ButtonPressed(mTitleTextField:String,mNotesTextView:String,mReminder:String,completion:@escaping (_ result:Bool)->Void)
    {
        //notes not empty
        if mTitleTextField != "" && mNotesTextView != ""
        {
            titleStored = mTitleTextField
            noteStored = mNotesTextView
            reminderStored = mReminder
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let taskIs = UserNotes(context: context)
            
            if Reachability.isConnectedToNetwork() == true
            {
            print("Internet connection OK")
                
               ref?.childByAutoId().setValue(UserDataModel.addTask(title: titleStored!, notes: noteStored!, reminder:reminderStored!))
                
            } else
            {
                print("Internet connection FAILED")
                taskIs.username = "false"
            }
            
            taskIs.title = mTitleTextField
            taskIs.note = mNotesTextView
            taskIs.reminder = mReminder
            
            //save the data to core data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
        completion(true)
    }
    
    func mupdate(mTitleTextField:String,mNotesTextView:String,mKey:String,mReminder:String,completion:@escaping (_ result:Bool)->Void)
    {
            //notes not empty
            titleStored = mTitleTextField
            noteStored = mNotesTextView
            reminderStored = mReminder
            print("<<<<<<<",taskKey!)
            keyStored = mKey
            print(keyStored)
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let taskIs = UserNotes(context: context)
            
            if Reachability.isConnectedToNetwork() == true
            {
                print("Internet connection OK")
               
                ref?.child(keyStored).updateChildValues(UserDataModel.addTask(title: titleStored!, notes: noteStored!,reminder:reminderStored!))
            } else
            {
                print("Internet connection FAILED")
                taskIs.username = "false"
            }
            
            taskIs.title = mTitleTextField
            taskIs.note = mNotesTextView
            taskIs.reminder = mReminder
            
            //save the data to core data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        completion(true)
    }
}
