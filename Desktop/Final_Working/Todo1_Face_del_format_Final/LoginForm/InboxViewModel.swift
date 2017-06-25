//  InboxViewModel.swift
//Purpose:
    //1.Used for Data Store to Firebase and Coredata and synchronize with eachother.


import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
var taskKey :String?

class InboxViewModel
{
    var ref:FIRDatabaseReference?
    init()
    {
        //set the firebase refrence
        ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()!.currentUser!.uid))
    }
    func fetchData(completion:@escaping (_ result:Bool)->Void)
    {
        //Check user is connected to network or not
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
            //Retrive data
            DataBaseModels.newUpdateData(completion:
            {
                isDone in
                if isDone
                {
                    completion(true)
                }
            })
            //If any offline data stored then put that data to firebase
            print("aftr offline stored data count=",currentUserData.count)
            
            for i in 0..<currentUserData.count
            {
                ref?.child("Data").childByAutoId().setValue(UserDataModel.addTask(
                    title: (currentUserData[i].value(forKey: "title") as? String)!,
                    notes: (currentUserData[i].value(forKey:"note") as? String)!,
                    reminder: (currentUserData[i].value(forKey:"reminder") as? String)!))
            }
            //remove previous core data
            DataBaseModels.removeCoreData()
            if archiveState
            {
                print("after removing core data count=",currentUserData.count)
                    //Retrieve the posts and listen for changes
                self.ref?.child("Archive").observeSingleEvent(of: .value, with:
                {
                    (snapshot) in
                    for rec in snapshot.children
                    {
                        taskKey = (rec as! FIRDataSnapshot).key
                        
                        //Try to convert the value of the data to string
                        let post = (rec as! FIRDataSnapshot).value as? [String:String]
                        
                        //code to executed when a child is added to the users, take the value from the snapshot and added it to the core data
                        if let actualPost = post
                        {
                            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                            
                            let taskUP = UserNotes(context: context)
                            
                            taskUP.note = actualPost["note"]
                            taskUP.title = actualPost["title"]
                            taskUP.reminder = actualPost["reminder"]
                            taskUP.key = taskKey
                            
                            let dictArch = ["note":actualPost["note"],"title":actualPost["title"],"reminder":actualPost["reminder"],"rec":taskKey]
                            
                            myArchData.append(dictArch as! [String : String])
                            
                            //save the data to core data
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            DataBaseModels.updateData(completion:
                            {
                                isDone in
                                if isDone
                                {
                                    completion(true)
                                    LoadingIndicatorView.hide()
                                }
                            })
                        }
                    }
                })
            }
            if trashState
            {
                print("after removing core data count=",currentUserData.count)
                //Retrieve the posts and listen for changes
                self.ref?.child("Delete").observeSingleEvent(of: .value, with:
                    {
                        (snapshot) in
                        for rec in snapshot.children
                        {
                            taskKey = (rec as! FIRDataSnapshot).key
                            
                            //Try to convert the value of the data to string
                            let post = (rec as! FIRDataSnapshot).value as? [String:String]
                            
                            //code to executed when a child is added to the users, take the value from the snapshot and added it to the core data
                            if let actualPost = post
                            {
                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                
                                let taskUP = UserNotes(context: context)
                                
                                taskUP.note = actualPost["note"]
                                taskUP.title = actualPost["title"]
                                taskUP.reminder = actualPost["reminder"]
                                taskUP.key = taskKey
                                
                                let dictTrash = [
                                        "note":actualPost["note"],
                                        "title":actualPost["title"],
                                        "reminder":actualPost["reminder"],
                                    "rec":taskKey]
                                
                                myTrashData.append(dictTrash as! [String : String])
                                
                                //save the data to core data
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                DataBaseModels.updateData(completion:
                                    {
                                        isDone in
                                        if isDone
                                        {
                                            completion(true)
                                            LoadingIndicatorView.hide()
                                        }
                                })
                            }
                        }
                })
            }
            else
            {
                print("after removing core data count=",currentUserData.count)
                //Retrieve the posts and listen for changes
                self.ref?.child("Data").observeSingleEvent(of: .value, with:
                {
                    (snapshot) in
                    for rec in snapshot.children
                    {
                        taskKey = (rec as! FIRDataSnapshot).key
                        //Try to convert the value of the data to string
                        let post = (rec as! FIRDataSnapshot).value as? [String:String]
                        //code to executed when a child is added to the users, take the value from the snapshot and added it to the core data
                        if let actualPost = post
                        {
                            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                            
                            let taskUP = UserNotes(context: context)
                            
                            taskUP.note = actualPost["note"]
                            taskUP.title = actualPost["title"]
                            taskUP.reminder = actualPost["reminder"]
                            taskUP.key = taskKey
                            
                            let dict = [
                                "note":actualPost["note"],
                                "title":actualPost["title"],
                            "reminder":actualPost["reminder"],
                                "rec":taskKey]
                            
                            myData.append(dict as! [String : String])
                            
                            if taskUP.reminder != ""
                            {
                                myRemdData.append(dict as! [String : String])
                            }
                            
                            //save the data to core data
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            DataBaseModels.updateData(completion:
                            {
                                isDone in
                                if isDone
                                {
                                    completion(true)
                                    LoadingIndicatorView.hide()
                                }
                            })
                        }
                    }
                })
            }
        }
        else
        {
            print("Internet connection FAILED")
            
            //get the updated data from core data
            DataBaseModels.updateData(completion:
            {
                isDone in
                if isDone
                {
                    completion(true)
                    LoadingIndicatorView.hide()
                }
            })
        }
    }
}
