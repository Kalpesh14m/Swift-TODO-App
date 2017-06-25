//RegisterViewModel.swift
//Purpose:
    //1.Used for Data Store to Firebase and Coredata and synchronize with eachother.

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegViewModel:NSObject
{
    var ref:FIRDatabaseReference?
    var databaseHandler:FIRDatabaseHandle?
    override init()
    {
        ref = FIRDatabase.database().reference()
    }
    
    func checkValidUser(
        firstname_store:String,
        lastname_store:String,
        username_store:String,
        pass_store:String,
        repass_store:String,
        isEmailAddressValid:Bool,
        isPasswordValid:Bool,
        isMobileValid:Bool,
        mobile_store:String,
        completion:@escaping (_ isSucces:Bool) -> Void)
    {
        if username_store != "" &&
            pass_store != "" &&
            repass_store != "" &&
            isEmailAddressValid == true &&
            isPasswordValid == true &&
            isMobileValid == true
        {
            FIRAuth.auth()?.createUser(withEmail: username_store, password: pass_store, completion:
            {
                (users,error) in
                if error != nil
                {
                    print("Error")
                    completion(false)
                }
                else
                {
                    UserDefaults.standard.set(users?.email, forKey: "CurrentUser")
                    UserDefaults.standard.set(firstname_store, forKey: "UserFirstName")
                    UserDefaults.standard.set(lastname_store, forKey: "UserLastName")
                    UserDefaults.standard.synchronize()
                    //Write data on firebase
                    self.ref?.child("Users").child(users!.uid).setValue([
                        "Profile":UserPostModel.addProfile(
                                firstName:firstname_store,
                                lastName:lastname_store,
                                email:username_store,
                                password:pass_store,
                                mobile:mobile_store)
                            ])
                    // Retrieve the posts and listen for changes
                    self.databaseHandler = self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Data").child("Profile").observe(.value, with:
                    {
                        (snapshot) in
                        //Try to convert the value of the data to string
                        let post = snapshot.value as? [String:String]
                        //code to executed when a child is added to the users take the value from the snapshot and added it to the core data
                        if let actualPost = post
                        {
                            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                            let taskUP = UserData(context: context)
                            taskUP.firstname = actualPost["firstname"]
                            taskUP.lastname = actualPost["lastname"]
                            taskUP.mobile = actualPost["mobile"]
                            taskUP.username = actualPost["username"]
                            taskUP.password = actualPost["password "]
                            //save the data to core data
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        }
                    })
                }
            })
        }
        completion(true)
    }
}
