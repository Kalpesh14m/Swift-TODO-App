//  LoginViewPresenter.swift
//Purpose:
    //1.Used for Pass data to model for validation.

import Foundation
import FirebaseAuth

protocol loginProtocolDelegate
{
    func setEmailPassword(setEmailText:String,setPassText:String)
    func setEmail(setEmailText:String)
    func setpassword(setPassText:String)
    func displayAlertBox(msg:String)
}

class LoginViewPesenter:NSObject
{
    //protocol object
    var loginModel:LoginViewModel?
    
    var mLoginProtocolObj:loginProtocolDelegate?

    init(loginProtocolObj:loginProtocolDelegate)
    {
        mLoginProtocolObj = loginProtocolObj
        loginModel = LoginViewModel()
    }

    //code to display empty text fiels
    func isEmptyTextFields(emailText:String,passText:String)
    {
    if((emailText.isEmpty) && (passText.isEmpty))
     {
        print("Your username and password is empty")
        mLoginProtocolObj?.setEmailPassword(setEmailText: "Enter Email", setPassText: "Enter Password")
     }
     else
     {
       if((emailText.isEmpty))
       {
          print("Your Email is empty")
          mLoginProtocolObj?.setEmail(setEmailText: "Enter Email")
        }
        else
        {
          if((passText.isEmpty))
          {
            print("Your password is empty")
            mLoginProtocolObj?.setpassword(setPassText: "Enter Password")
          }
        }
     }
     }

    func checkAuthorizedUser(userEmail:String,userPassword:String,completion:@escaping (_ result:Bool)->Void)
    {
        loginModel?.checkAuthorizedUser(userEmail:userEmail,userPassword:userPassword, completion: { isSucces in
            
            if (isSucces)
            {
                completion(true)
            }
            else
            {
                self.mLoginProtocolObj?.displayAlertBox(msg: "Username and Password is wrong")
                completion(false)
            }
            
        })
     }
    
    func saveFirstLastName(completion:@escaping (_ result:Bool)->Void)
    {
        loginModel?.saveFirstLastName(completion: { isSucces in
        
            if (isSucces)
            {
                completion(true)
            }
            else
            {
               // self.mLoginProtocolObj?.displayAlertBox(msg: "Username and Password is wrong")
                print("Your not enter first name and last name while registration")
                completion(false)
            }
        })
    }

}
