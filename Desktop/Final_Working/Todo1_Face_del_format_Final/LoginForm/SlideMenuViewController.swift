//  SlideMenuViewController.swift
//Purpose:
    //1.Used for SideMenu.
    //2.Used for show user profile like:
        //2.1.user Profile Image
        //2.2.user Profile Background Image.
        //2.3.user First and Last Name.
        //2.4.user Email.
    //3.Used for show Menu like:
        //3.1.Notes
        //3.2.Archive
        //3.3.Trash
        //3.3.Reminder
        //3.4.Logout
        //3.5.Setting
    //4.If there is Internet connection is available then only user gets logout from account.

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class SlideMenuViewController: UITableViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIGestureRecognizerDelegate,
    ImageCropViewControllerDelegate
{
  
    @IBOutlet weak var mtakeimages: UIImageView!
    @IBOutlet weak var mtakebackimg: UIImageView!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mLastName: UILabel!
    @IBOutlet weak var mEmail: UILabel!
    
    var ref:FIRDatabaseReference?
    var profile:String = ""
    var profileback:String = ""
    var slidePresenter = SlideViewPesenter()

    var storage:FIRStorageReference?
    var data = Data()
    
    let metaData = FIRStorageMetadata()
    
    var section: Int! = 0
    var indexrow: Int! = 0
    var mCircleProfile : Bool = false
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userFirstName = UserDefaults.standard.value(forKey: "user_first_name") as! String
        userLastName = UserDefaults.standard.value(forKey: "user_last_name") as! String

        mName.text = userFirstName+"  "+userLastName

        mLastName.text = userLastName
        mLastName.isHidden = true
        ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()!.currentUser!.uid))
      
        storage = FIRStorage.storage().reference().child("Users")
        
        metaData.contentType = "image/jpeg"

        imagePicker.delegate = self
        mtakeimages.isUserInteractionEnabled = true
        mtakebackimg.isUserInteractionEnabled = true
        
        mtakeimages.layer.cornerRadius = mtakeimages.frame.width/2
        mtakeimages.layer.masksToBounds = true
        mtakeimages.layer.borderWidth = 1
 
        mEmail.text = currentuser

        //store true or false value
        let isUserProfileSet = UserDefaults.standard.bool(forKey: "isUserProfileSet")
        let isUserBackProfileSet = UserDefaults.standard.bool(forKey: "isUserBackProfileSet")
        
        if Reachability.isConnectedToNetwork() == true
        {
            slidePresenter.saveImageData(completion:
            {
                isSucces in
                if (isSucces)
                {
                    self.profile = UserDefaults.standard.string(forKey: "user_profile_imgurl")!
                    
                    let profileImageUrl = URL(string:  self.profile as String)
                    
                    print("Image Url",profileImageUrl!)
                    
                    if let url = profileImageUrl
                    {
                        self.mtakeimages.sd_setImage(with: url as URL!)
                    }
                    
                    self.profileback = UserDefaults.standard.string(forKey: "user_background_imgurl")!
                    
                    let backProfileImageUrl = URL(string: self.profileback as String)
                    
                    print("Image Url",backProfileImageUrl!)
                    
                    if let url = backProfileImageUrl
                    {
                        self.mtakebackimg.sd_setImage(with: url as URL!)
                    }
                }
            })
        }
        else
        {
            if isUserProfileSet
            {
                self.profile = UserDefaults.standard.string(forKey: "user_profile_imgurl")!
                    
                let profileImageUrl = URL(string:  self.profile as String)
                    
                print("Image Url",profileImageUrl!)
                    
                if let url = profileImageUrl
                {
                    self.mtakeimages.sd_setImage(with: url as URL!)
                }
            }
            if isUserBackProfileSet
            {
                self.profileback = UserDefaults.standard.string(forKey: "user_background_imgurl")!
                    
                let backProfileImageUrl = URL(string: self.profileback as String)
                    
                print("Image Url",backProfileImageUrl!)
                    
                if let url = backProfileImageUrl
                {
                    self.mtakebackimg.sd_setImage(with: url as URL!)
                }
            }
        }
    }
    
    @IBAction func selectBackImage(_ sender: UITapGestureRecognizer)
    {
        self.choosePhoto()
        self.mCircleProfile = true
    }
 
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer)
    {
        self.choosePhoto()
        mCircleProfile = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        else
        {
            dismiss(animated: true, completion: nil)
            return
        }
        if mCircleProfile == true
        {
            UserDefaults.standard.removeObject(forKey: "user_background_imgurl")
            mtakebackimg.image = selectedImage
      
            //post background image to firebase
            UserDefaults.standard.set(true, forKey: "isUserBackProfileSet")
            UserDefaults.standard.synchronize()
        
            data = UIImageJPEGRepresentation(selectedImage, 0.8)! as Data
        
        storage?.child((FIRAuth.auth()?.currentUser?.uid)!).child("Profile").child("backprofileimg").put(data, metadata: metaData, completion:
            {
                (metadata,error) in
                
                if error != nil
                {
                    print("Failed to upload image")
                }
                else
                {
                    if let downloadUrl = metadata?.downloadURL()?.absoluteString
                    {
                    self.ref?.child("Profile").updateChildValues(["user_background_imgurl":downloadUrl])
                        print("URL - - >",downloadUrl)
                        self.slidePresenter.saveImageData(completion:
                        {
                            isSucces in
                            if (isSucces)
                            {
                                
                            }
                        })
                    }
                }
                
            })
        }
        else
        {
            UserDefaults.standard.removeObject(forKey: "user_profile_imgurl")
            
            mtakeimages.image = selectedImage
            
            //post profile image to firebase
            UserDefaults.standard.set(true, forKey: "isUserProfileSet")
            UserDefaults.standard.synchronize()
            
            data = UIImageJPEGRepresentation(selectedImage, 0.8)! as Data
        storage?.child((FIRAuth.auth()?.currentUser?.uid)!).child("Profile").child("profileimg").put(data, metadata: metaData, completion:
            {
                (metadata,error) in
                
                if error != nil
                {
                    print("Failed to upload image")
                }
                else
                {
                    if let downloadUrl = metadata?.downloadURL()?.absoluteString
                    {
                    self.ref?.child("Profile").updateChildValues(["user_profile_imgurl":downloadUrl])
                        self.slidePresenter.saveImageData(completion:
                        {
                            isSucces in
                            if (isSucces)
                            {
                                
                            }
                        })
                    }
                }
                
            })
        }
        if mCircleProfile
        {
            dismiss(animated: true, completion: nil)
        }
        else
        {
            dismiss(animated: true)
            {
                [unowned self] in
                self.openEditor()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        section = indexPath.section
        indexrow = indexPath.row
            
        //Notes
        if section == 0 && indexrow == 0
        {
            reminderState = false
            archiveState = false
            trashState = false
        }
        
        //Reminder
        if section == 0 && indexrow == 1
        {
            reminderState = true
            archiveState = false
            trashState = false
        }
        
        //Archive
        if section == 1 && indexrow == 0
        {
            reminderState = false
            archiveState = true
            trashState = false
        }
        
        //Trash
        if section == 1 && indexrow == 1
        {
            reminderState = false
            archiveState = false
            trashState = true
        }
        
        //Logout
        if section == 2 && indexrow == 2
        {
            if Reachability.isConnectedToNetwork() == true
            {
                print("Internet connection OK")
                let alert = UIAlertController(title: "Really Want to logout..?", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.default, handler:
                {
                    action in
                    self.logoOut()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                // show the alert
               self.present(alert, animated: true, completion: nil)
            }
            else
            {
                print("Please Check Internet Connection")
                // create the alert
                let alert = UIAlertController(title: "No Internet Connection📵", message: "Please Check your Internet Connection🔃", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Ok...", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
     }
    func logoOut()
    {
        slidePresenter.logout(completion:
        {
            isSucces in
            if (isSucces)
            {
                do
                {
                    if GIDSignIn.sharedInstance().currentUser != nil
                    {
                        //Google Login
                        GIDSignIn.sharedInstance().signOut()
                        print("Google Logout Successfully")
                        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.present(loginVC, animated: true, completion: nil)
                    }
                    else
                    {
                        print("General User Logout")
                        try! FIRAuth.auth()?.signOut()
                        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.present(loginVC, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    func choosePhoto()
    {
        self.imagePicker.delegate = self
        
        let alertController = UIAlertController(title:"Add a Picture", message:"Choose From",preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title:"Camera",style: .default)
        {
            (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated:true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title:"Photo Library",style: .default)
        {
            (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated:true, completion: nil)
        }
        
        let savedPhotoAction = UIAlertAction(title:"Saved Photo Album",style: .default)
        {
            (action) in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.present(self.imagePicker, animated:true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title:"Cancel",style: .destructive, handler: nil)
 
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(savedPhotoAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func openEditor()
    {
        guard let selectedImage = mtakeimages.image else
        {
            return
        }
        let controller = ImageCropViewController()
        controller.delegate = self
        controller.image = selectedImage
        controller.blurredBackground = true
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    func imageCropViewControllerDidCancel(_ controller: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewControllerSuccess(_ controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!)
    {
        mtakeimages.image = croppedImage
        self.dismiss(animated: true, completion: nil)
    }
}
