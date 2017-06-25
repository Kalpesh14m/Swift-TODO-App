//
//  CustomCell.swift
//  Example
//
//  Created by BridgeLabz Solution LLP on 04/05/17.
//  Copyright © 2017 NSHint. All rights reserved.
//

import Foundation
import UIKit

class CustomCell:UICollectionViewCell{
    
    @IBOutlet var textContent: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.textContent.sizeToFit()
        super.awakeFromNib()
        
    }
    
}
