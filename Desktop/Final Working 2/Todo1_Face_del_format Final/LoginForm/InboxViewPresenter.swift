//
//  InboxPresenter.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 4/20/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation

class InboxViewPesenter
{
    // object
    var inboxModel = InboxViewModel()
    

    func fetchData(completion:@escaping (_ result:Bool)->Void)
    {
        inboxModel.fetchData(completion:
        {
            isSucces in
            
            if (isSucces)
            {
                completion(true)
            }
            else
            {
                completion(false)
            }
            
        })
    }
}
