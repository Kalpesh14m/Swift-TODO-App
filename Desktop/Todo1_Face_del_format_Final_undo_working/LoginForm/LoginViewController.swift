//  LoginViewController.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 3/15/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.


import UIKit
import CoreData
import Firebase
import FirebaseAuth
import SVProgressHUD
import GoogleSignIn


var currentuser:String = ""
var userDataToPrint = "note"

class LoginViewController: UIViewController,
    UITextFieldDelegate,
    loginProtocolDelegate,
    UIViewControllerTransitioningDelegate,
    GIDSignInUIDelegate,
    GIDSignInDelegate
{
    //MARK:Variable Declaration
    @IBOutlet weak var mEmailTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    @IBOutlet weak var mSignIn: TKTransitionSubmitButton!
    @IBOutlet weak var mSignUp: UIButton!
    @IBOutlet weak var mLogInFb: UIButton!
    @IBOutlet weak var mLogInG: GIDSignInButton!
  
    var user:String?
    var pass:String?
    var loginPresenter:LoginViewPesenter?
    var InternetConProtocol : RegisterProtocolDelegate?
    var databaseHandler:FIRDatabaseHandle?
    var ref:FIRDatabaseReference?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupAttribute()
        googSignIn()
    }
    func googSignIn()
    {
        //GoogleSigIn
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self

    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if error == nil
        {
            print("Ok...",user.profile.email)
        }
        else
        {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication
            else
        {
            return
        }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
            accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential)
        {
            (firebaseuser, error) in
            if let error = error
            {
                print(error.localizedDescription)
                return
            }
            else
            {
                let email = user.profile.email
                let Profileimg = user.profile.imageURL(withDimension: 300)
                let uid = user.userID
                let backImg = user.profile.imageURL(withDimension: 300)
                let givenName = user.profile.givenName
                let familyName = user.profile.familyName
                let mobile = "9876543210"
                let password = "********"
                
                UserDefaults.standard.set(email, forKey: "CurrentUser")
                UserDefaults.standard.set(givenName, forKey: "UserFirstName")
                UserDefaults.standard.set(familyName, forKey: "UserLastName")
                UserDefaults.standard.synchronize()
                //Write data on firebase
                self.ref?.child("Users").child(uid!).setValue([
                    "Profile":UserPostModel.addProfile(
                        firstName: givenName!,
                        lastName: familyName!,
                        email: email!,
                        password: password,
                        mobile: mobile)
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                self.present(vc!, animated: true, completion: nil)
                
            }
            print("User is LogIn")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
    {
        let firebaseAuth = FIRAuth.auth()
        do
        {
            try firebaseAuth?.signOut()
        }
        catch let signOutError as NSError
        {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func GoogleSignInBtnClk(_ sender: Any)
    {
        //GoogleSignInBtnClk
        GIDSignIn.sharedInstance().signIn()
    }
    func setupAttribute()
    {
        //Setup Button Attributes
        loginPresenter = LoginViewPesenter(loginProtocolObj: self)
        //Set Buttons Attributes
        mSignIn.layer.cornerRadius = 20
        mLogInFb.layer.cornerRadius = 20
        mLogInG.layer.cornerRadius = 20
        
        self.mEmailTextField.delegate = self
        self.mPasswordTextField.delegate = self
    }
    @IBAction func mForgotPassword(_ sender: Any)
    {
        //ForgetPassword
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
        present(vc, animated: true, completion: nil)
    }
    
    //MARK:Login Button
    @IBAction func loginButton(_ sender: Any)
    {
        //Login Btn Clk
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
            
            //LoadingIndicatorView.show(self.view, loadingText: "LOADING")
            let userEmail = mEmailTextField.text;
            let userPassword = mPasswordTextField.text;
            
            loginPresenter?.isEmptyTextFields(
                emailText:mEmailTextField.text!,
                passText:mPasswordTextField.text!)
            
            loginPresenter?.checkAuthorizedUser(
                userEmail:userEmail!,
                userPassword:userPassword!,
                completion:
            {
                isSucces in
                if (isSucces)
                {
                    LoadingIndicatorView.hide()
                    //SVProgressHUD.showSuccess(withStatus: "Login Successful👍")
                    self.loginPresenter?.saveFirstLastName(completion:
                    {
                        isSucces in
                        if (isSucces)
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                            self.mSignIn.animate(1, completion:
                            {
                                () -> () in
                                vc?.transitioningDelegate = self
                                self.present(vc!, animated: true, completion: nil)
                            })
                        }
                    })
                }
                else
                {
                    LoadingIndicatorView.hide()
                }
            })
        }
        else
        {
            InternetConProtocol?.displayAlertBox(msg: "Please Check Internet Connection...")
            let alert = UIAlertController(title: "❗️Connection Problem..❌", message: "Please Check Internet Connection...📵", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Ok...", style: UIAlertActionStyle.cancel, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    //TKTransitionSubmitButton Animation delegate
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return TKFadeInAnimator(transitionDuration: 1, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return nil
    }
    
    
    
    //Display alert
    func displayMyAlertMessage(userMessage : String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    func setEmailPassword(setEmailText: String, setPassText: String)
    {
        self.mEmailTextField.text = setEmailText
        self.mPasswordTextField.text = setPassText
        
        self.mEmailTextField.textColor = UIColor.red
        self.mPasswordTextField.textColor = UIColor.red
        self.mPasswordTextField.isSecureTextEntry = false
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 2), execute:{
            self.mEmailTextField.text = ""
            self.mPasswordTextField.text = ""
            self.mPasswordTextField.isSecureTextEntry = true })
    }
    
    func setEmail(setEmailText:String)
    {
        self.mEmailTextField.text = setEmailText
        self.mEmailTextField.textColor = UIColor.red
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 2), execute: {
            self.mEmailTextField.text = ""  })
    }

    func setpassword(setPassText:String)
    {
        self.mPasswordTextField.text = setPassText
        self.mPasswordTextField.textColor = UIColor.red
        self.mPasswordTextField.isSecureTextEntry = false
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 2), execute:{
        self.mPasswordTextField.text = ""
        self.mPasswordTextField.isSecureTextEntry = true  })
    }

    func displayAlertBox(msg:String)
    {
        self.displayMyAlertMessage(userMessage: msg)
    }
    
    @IBAction func signUp(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegViewController") as! RegViewController
        self.present(vc, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        mEmailTextField.resignFirstResponder()
        mPasswordTextField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
}
