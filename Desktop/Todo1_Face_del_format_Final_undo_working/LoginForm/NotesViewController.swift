//
//  NotesViewController.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 3/25/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth

var reminderDateM = ""
var titleStored:String?
var noteStored:String?
var reminderStored:String?
var keyStored = String()

class NotesViewController: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var mTitleTextField: UITextField!
    @IBOutlet weak var mNotesTextView: UITextView!
    @IBOutlet weak var mReminder: UITextField!
    
    @IBOutlet weak var ShowCurrentTime: UILabel!
    var mTitleTextFieldData:String?
    var mNotesTextViewData:String?
    var mReminderData:String?
    var mKey :String?
    var notesPresenter = NotesViewPresenter()
    var mUpdate = false
    var ref:FIRDatabaseReference?

    //create a new button
    let backBtn: UIButton = UIButton()
    let reminderBtn: UIButton = UIButton()
    let optionBtn: UIButton = UIButton()
    let pinBtn: UIButton = UIButton()
    let ColorBtn: UIButton = UIButton()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myDate()
      //  showAnimate()
        if cell
        {
            mTitleTextField.text = mTitleTextFieldData
            mNotesTextView.text = mNotesTextViewData
            mReminder.text = mReminderData
            cell = false
        }
        
        ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()!.currentUser!.uid)).child("Data")

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.white
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(loadReminderData), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showNavigation), name: NSNotification.Name(rawValue: "save"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadColor), name: NSNotification.Name(rawValue: "loadColor"), object: nil)
        
    }
    //******************************************************//
    //**Function is used to show time on label on AddNotes**//
    func myDate()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let dateString = formatter.string(from: Date())
        ShowCurrentTime.text = "Edited: \(dateString)"
        print("Current Time :=>",dateString)
    }
    //******************************************************//

    func showNavigation()
    {
        navigationController?.navigationBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool)
    {
        //Button Method Call
        backBtnM()
        reminderBtnM()
       // PinBtnM()
        //OptionBtnM()
        ColorBtnM()
        //Placing Button on Navigation
        let BackbarButton = UIBarButtonItem(customView: backBtn)
        let reminderbarButton = UIBarButtonItem(customView: reminderBtn)
        //let optionbarButton = UIBarButtonItem(customView: optionBtn)
        //let pinbarButton = UIBarButtonItem(customView: pinBtn)
        let ColorbarButton = UIBarButtonItem(customView: ColorBtn)
        
        //assign button to navigationbar
        //Left Button
        self.navigationItem.leftBarButtonItem = BackbarButton
        //Right Button
        self.navigationItem.setRightBarButtonItems([reminderbarButton,ColorbarButton], animated: true)
        navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.8
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2
        navigationController?.navigationBar.layer.backgroundColor = UIColor.white.cgColor
        
    }
//_____________Back Btn______________
    func backBtnM()
    {
        //set image for button
        backBtn.setImage(UIImage(named: "backicon"), for: UIControlState.normal)
        //add function for button
        backBtn.addTarget(self, action: #selector(NotesViewController.ButtonPressed), for: UIControlEvents.touchUpInside)
        //set frame
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
    }
    //This method will call when you press notes save button.
    func ButtonPressed()
    {

        if mUpdate{
            notesPresenter.update(mTitleTextField: mTitleTextField.text!, mNotesTextView: mNotesTextView.text!,mReminder:mReminder.text!,mKey:mKey!,completion:
                {
                    isSucces in
                if (isSucces)
                {
                    print("hello button is pressed")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    
                    self.navigationController?.pushViewController(vc, animated: false)
                    //self.removeAnimate()

                    }
            })
        }
        else
        {
            notesPresenter.ButtonPressed(mTitleTextField: mTitleTextField.text!, mNotesTextView: mNotesTextView.text!,mReminder:mReminder.text!,completion: { isSucces in
                if (isSucces)
                {
                    print("hello button is pressed")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    
                    self.navigationController?.pushViewController(vc, animated: false)
                    //self.removeAnimate()
                }
            })
        }
    }
//_____________Reminder Btn______________
    func reminderBtnM()
    {
        //set image for button
        reminderBtn.setImage(UIImage(named: "Reminder"), for: UIControlState.normal)
        //add function for button
        reminderBtn.addTarget(self, action: #selector(NotesViewController.reminderBtnClk), for: UIControlEvents.touchUpInside)
        //set frame
        reminderBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
    }
//______________Func for get reminder date_______________//
    func getreminderDate(reminder : String)
    {
        reminderDateM = reminder
        print("#@#@#@#@#@#@#@#@#@#",reminderDateM)
    }
//___________Reminder Button __________//
    func reminderBtnClk()
    {
        print("Reminder Button is Clicked")
        let pop = PopupController
            .create(self)
        
        let popView = ShowMainReminderView.instance()
        popView.closeHandler =
            {
                _ in
                
                self.mReminder.text = reminderDateM
                pop.dismiss()
        }
        pop.show(popView)
    }
    func showRemider(){
        navigationController?.navigationBar.isHidden = true
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "reminderPopUpView") as! ShowMainReminderView
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }

//_____________Option Btn______________
    func OptionBtnM()
    {
        //set image for button
        optionBtn.setImage(UIImage(named: "deletemenu"), for: UIControlState.normal)
        //add function for button
        optionBtn.addTarget(self, action: #selector(NotesViewController.ButtonPressed), for: UIControlEvents.touchUpInside)
        //set frame
        optionBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
    }
    func option()
    {
        print("Option Btn Clk")
    }
//_____________Pin Btn______________
    func PinBtnM()
    {
        //set image for button
        pinBtn.setImage(UIImage(named: "pin"), for: UIControlState.normal)
        //add function for button
        pinBtn.addTarget(self, action: #selector(NotesViewController.Pin), for: UIControlEvents.touchUpInside)
        //set frame
        pinBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
    }
    func Pin()
    {
        print("Pin BtnClk")
    }
//_____________Color Btn______________

    func ColorBtnM()
    {
        //set image for button
        ColorBtn.setImage(UIImage(named: "colorIcon"), for: UIControlState.normal)
        //add function for button
        ColorBtn.addTarget(self, action: #selector(NotesViewController.Color), for: UIControlEvents.touchUpInside)
        //set frame
        ColorBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
    }
    
    func loadColor()
    {
    }

    func Color()
    {
        PopupController
            
            .create(self)
            .customize(
                [     .layout(.center) ,
                      .animation(.fadeIn),
                      .scrollable(false),
                      .backgroundStyle(.blackFilter(alpha: 0.1)),
                      .dismissWhenTaps(true)
                    
                ]
            )
            .didShowHandler
            {
                _ in
                print("opened")
                
            }
            .didCloseHandler
            {
                _ in
                print("closed")
            }
            .show(ColorPickerView.instance())
        
    }
//_________________________________________________

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //placeholder name
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(textView.text == "Note")
        {
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if(textView.text == "")
        {
            textView.text = "Note"
        }
        textView.resignFirstResponder()
    }
    
    //Functions
    //Show animation Functions
    func showAnimate()
    {
        //set the popup animations
        //self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        //set back view as visible
        //self.view.alpha = 1.0
        UIView.animate(withDuration: 1.0, animations:
        {
            //self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        })
    }
    //remove animation when view return
    func removeAnimate()
    {
        //Animation for remove view
        UIView.animate(withDuration: 1.0, animations:
        {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            //self.view.alpha = 0.0
        },
        completion:
        {
            (finished: Bool) in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        })
    }
}
