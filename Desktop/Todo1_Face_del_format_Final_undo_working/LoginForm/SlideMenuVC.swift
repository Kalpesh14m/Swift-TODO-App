//
//  SlideMenuVC.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 3/23/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit

class SlideMenuVC: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var menuNameArray : Array = [String]()
    var menuImageArray : Array = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuNameArray = ["Notes","Reminders","Trash"]
        menuImageArray = [UIImage(named:"note")!,UIImage(named:"reminder")!,UIImage(named:"reminder")!]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
      return menuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }

}
