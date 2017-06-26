//
//  InboxModel.swift
//  Todo1.4
//
//  Created by BridgeLabz on 25/06/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation
class NotesModel
{
    var id:String?
    var title:String?
    var note:String?
    var reminder:String?
    var color:String?
    
    
    
    init(id:String?,
         title:String?,
         note:String?,
         reminder:String?,
         color:String?
    )
    {
        self.id = id
        self.title = title
        self.note = note
        self.reminder = reminder
        self.color = color
        
    }
}
