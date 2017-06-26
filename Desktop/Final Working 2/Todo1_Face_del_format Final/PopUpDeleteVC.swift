//
//  PopUpDeleteVC.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 6/14/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit
import Firebase
class PopUpDeleteVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PopupContentViewController
{

    @IBOutlet weak var tableView: UITableView!
    
    var menu : [String] = ["Unarchive","Delete","Make a copy","Send"]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //for table view border
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 1.0
        
//        //for shadow
//        let containerView:UIView = UIView(frame:self.tableView.frame)
//        containerView.backgroundColor = UIColor.clear
//        containerView.layer.shadowColor = UIColor.lightGray.cgColor
//        containerView.layer.shadowOffset = CGSize(width: -10, height: 10) //Left-Bottom shadow
//        containerView.layer.shadowOffset = CGSize(width: 10, height: 10) //Right-Bottom shadow
//        containerView.layer.shadowOpacity = 1.0
//        containerView.layer.shadowRadius = 2
//        
//        //for rounded corners
//        tableView.layer.cornerRadius = 10
//        tableView.layer.masksToBounds = true
//        self.view.addSubview(containerView)
//        containerView.addSubview(tableView)
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize
    {
        return CGSize(width: 500, height: 175)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menu.count
    }
    
    class func instance() -> PopUpDeleteVC{
        let storyboard = UIStoryboard(name: "PopUpDeleteVC", bundle: nil)
        return storyboard.instantiateInitialViewController() as! PopUpDeleteVC
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpDeleteVCCell") as! PopUpDeleteVCCell
        cell.labelName.text = menu[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = indexPath.row
        
        switch index
        {
        case 0:
            
           DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute:
            {
            self.view.removeFromSuperview()
           })

            break
            
        case 1:
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute:
            {
                 NotificationCenter.default.post(name: Notification.Name(rawValue:"SelectIndex"), object: nil)
                self.view.removeFromSuperview()
            })
            
            break
            
        case 2:
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute:
                {
                self.view.removeFromSuperview()
            })
            
            break
        case 3:
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
                self.view.removeFromSuperview()
            })
            break
            
        default:
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
                self.view.removeFromSuperview()
            })
            
            break
        }
    }

}
