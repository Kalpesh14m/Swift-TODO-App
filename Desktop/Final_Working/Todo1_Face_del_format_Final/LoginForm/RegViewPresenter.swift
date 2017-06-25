//RegisterViewPresenter.swift
//Purpose:
    //1.Used for Pass data to model for validation.

import Foundation
import FirebaseAuth

protocol RegisterProtocolDelegate
{
      func displayAlertBox(msg:String)
}

class RegViewPresenter:NSObject
{
    var mRegisterProtocolObject:RegisterProtocolDelegate?
    var regModel:RegViewModel?
    
    init(RegisterProtocolObj:RegisterProtocolDelegate)
    {
        mRegisterProtocolObject = RegisterProtocolObj
        regModel = RegViewModel()
    }
    
    //Email regx validation
    func isValidEmailAddress(emailAddressString: String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError
        {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    //Password regx validation
    func isValidPassword(passswordString: String) -> Bool
    {
        var returnValue = true
        let passwordRegEx = "^([a-zA-Z0-9@*#]{8,15})$"
        
        do {
            let regex = try NSRegularExpression(pattern: passwordRegEx)
            let nsString = passswordString as NSString
            let results = regex.matches(in: passswordString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError
        {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    //Mobile Number validation
    func isValidMobileNumber(value: String) -> Bool
    {
        let phone_regx = "^([98]{1})([123456789]{1})([0-9]{8})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@",phone_regx)
        let result = phoneTest.evaluate(with: value)
        return result
    }

      func checkEmptyField(username_store:String,pass_store:String,repass_store:String)
      {
        if (username_store.isEmpty) || (pass_store.isEmpty) || (pass_store.isEmpty)
        {
            mRegisterProtocolObject?.displayAlertBox(msg: "All fields are required")
            print("insert all value")
            return
        }
      }
    
    func checkPassRepass(pass_store:String,repass_store:String)
    {
        if pass_store != repass_store
        {
            mRegisterProtocolObject?.displayAlertBox(msg: "Repeated password do not match")
            print("username and password not same")
            return
        }
    }
    
    func isEmailAddressValid(isEmailAddressValid:Bool)
    {
        if isEmailAddressValid == false
        {
            print("Email address is not valid")
            mRegisterProtocolObject?.displayAlertBox(msg: "Email address is not valid")
        }
    }
    
    func isPasswordValid(isPasswordValid:Bool)
    {
        if isPasswordValid == false
        {
            print("Password Must Be 8-15 Character Long")
            mRegisterProtocolObject?.displayAlertBox(msg: "Password Must Be 8-15 Character Long")
        }
    }
    
    func isMobileValid(isMobileValid:Bool)
    {
        if isMobileValid == false
        {
            print("Mobile number should be 10 digit of It starts with 9 or 8")
            mRegisterProtocolObject?.displayAlertBox(msg: "Mobile No📲 Must Be 10 digit or Start with '9️⃣/8️⃣'")
        }
    }
    
    //store data
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
            completion:@escaping (_ result:Bool)->Void)
    {
        regModel?.checkValidUser(
            firstname_store:firstname_store,
            lastname_store:lastname_store,
            username_store:username_store,
            pass_store:pass_store,
            repass_store:repass_store,
            isEmailAddressValid:isEmailAddressValid,
            isPasswordValid:isPasswordValid,
            isMobileValid:isMobileValid,
            mobile_store:mobile_store,
            completion:
        {
            isSuccess in
            if (isSuccess)
            {
                completion(true)
            }
            else
            {
                self.mRegisterProtocolObject?.displayAlertBox(msg: "User is Already Exits")
            completion(false)
            }
        })
    }
}
