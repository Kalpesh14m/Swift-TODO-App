//Purpose:
    //1.Used for Forget password when user forget password.


import UIKit
import Firebase
import FirebaseAuth

class ForgotPassViewController: UIViewController
{
    
//MARK: IBOutlet
    @IBOutlet weak var mEmailTextField: UITextField!
    
//MARK: viewDidLoad Function
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mEmailTextField.layer.borderWidth = 1
    }
    
//MARK: Reset Password Action
    @IBAction func resetPassword(_ sender: Any)
    {
        FIRAuth.auth()?.sendPasswordReset(withEmail: mEmailTextField.text!, completion:
        {
            (error) in
            if error == nil
            {
                print("An email with information how to reset password has been send to you. Thank You")
            }
            else
            {
                print("Error")
            }
        })
    }
    
//MARK: Back Button Action
    @IBAction func backToLogin(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(vc, animated: true, completion: nil)
    }
}
