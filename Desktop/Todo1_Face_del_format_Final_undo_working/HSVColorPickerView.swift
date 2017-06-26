//
//  HSVColorPickerView.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 6/13/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit

class HSVColorPickerView: UIViewController {

    @IBOutlet weak var colorPicker: SwiftHSVColorPicker!
    var selectedColor : UIColor = UIColor.white
    override func viewDidLoad() {
        super.viewDidLoad()

        colorPicker.setViewColor(selectedColor)
    }

    @IBAction func colorSelected(_ sender: Any) {
        let selectedColor = colorPicker.color
        print(selectedColor)
        NotificationCenter.default.post(name: Notification.Name(rawValue:"loadColor"), object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
   
}
