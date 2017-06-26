//Purpose:
    //1.Register New User

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class RegViewController: UIViewController,
    UITextFieldDelegate,
    RegisterProtocolDelegate
{
//MARK: Outlets
    @IBOutlet weak var mFirstName: FloatLabelTextField!
    @IBOutlet weak var mLastName: FloatLabelTextField!
    @IBOutlet weak var mEmailReg: UITextField!
    @IBOutlet weak var mPassReg: UITextField!
    @IBOutlet weak var mRepassReg: UITextField!
    @IBOutlet weak var mMobileReg: UITextField!
    @IBOutlet weak var mCreateAccount: UIButton!

//MARK: Register Presenter
    var registerPresenter:RegViewPresenter?

//MARK: ViewDidLoad Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        registerPresenter = RegViewPresenter(RegisterProtocolObj: self)
        self.mFirstName.delegate = self
        self.mLastName.delegate = self
        self.mEmailReg.delegate = self
        self.mPassReg.delegate = self
        self.mRepassReg.delegate = self
        self.mMobileReg.delegate = self
        mCreateAccount.layer.cornerRadius = 15
    }
    
//MARK: Create New user Button Action
    @IBAction func createNewAccount(_ sender: Any)
    {
        let firstname_store = mFirstName.text;
        let lastname_store = mLastName.text;
        let username_store = mEmailReg.text;
        let pass_store = mPassReg.text;
        let repass_store = mRepassReg.text;
        let mobile_store = mMobileReg.text;

//____________ check for empty fields ____________
        registerPresenter?.checkEmptyField(username_store:username_store!,
                                           pass_store:pass_store!,
                                           repass_store:repass_store!)
//________ Check password and repeated password match ________
        registerPresenter?.checkPassRepass(pass_store:pass_store!,
                                           repass_store:repass_store!)
//____________ Validate Email ____________
        let isEmailAddressValid = registerPresenter?.isValidEmailAddress(emailAddressString: username_store!)
//____________ Show Alert Box ____________
        registerPresenter?.isEmailAddressValid(
            isEmailAddressValid:isEmailAddressValid!)
//____________ Validate Password ____________
        let isPasswordValid = registerPresenter?.isValidPassword(passswordString: pass_store!)
//____________ Show Alert Box ____________
        registerPresenter?.isPasswordValid(isPasswordValid:isPasswordValid!)
//____________ Validated Mobile Number ____________
        let isMobileValid = registerPresenter?.isValidMobileNumber(value: mMobileReg.text!)
//____________ Show Alert Box ____________
        registerPresenter?.isMobileValid(isMobileValid:isMobileValid!)
//____________pass data if valid user ____________
        registerPresenter?.checkValidUser(
            firstname_store:firstname_store!,
            lastname_store:lastname_store!,
            username_store:username_store!,
            pass_store:pass_store!,
            repass_store:repass_store!,
            isEmailAddressValid:isEmailAddressValid!,
            isPasswordValid:isPasswordValid!,
            isMobileValid:isMobileValid!,
            mobile_store:mobile_store!,
            completion:
            {
                isSuccess in
                if (isSuccess)
                {
//____________display alert____________
                let myalert = UIAlertController(title:"Alert", message: "Registration is successful, Thank You", preferredStyle : UIAlertControllerStyle.alert)

                let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:
                {
                        (action:UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                myalert.addAction(okAction)
                self.present(myalert, animated: true, completion: nil)
            }
        })
    }

//________ If you already registerd go to login page _________
    @IBAction func alreadyReg(_ sender: UIButton)
    {
       let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
       present(vc, animated: true, completion: nil)
    }
//____________ Display Alert Box ____________
    func displayMyAlertMessage(userMessage : String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
    }
//Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        mFirstName.resignFirstResponder()
        mLastName.resignFirstResponder()
        mEmailReg.resignFirstResponder()
        mPassReg.resignFirstResponder()
        mRepassReg.resignFirstResponder()
        mMobileReg.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
//____________ Display Alert Box ____________
    func displayAlertBox(msg:String)
    {
        self.displayMyAlertMessage(userMessage: msg)
    }
}
