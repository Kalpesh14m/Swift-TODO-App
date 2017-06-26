//
//  SlideMenuPresenter.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 4/25/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation

class SlideViewPesenter
{
    var slideModel = SlideViewModel()
    
    func saveImageData(completion:@escaping (_ result:Bool)->Void)
    {
        slideModel.saveImageData(completion: {
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
    
    func logout(completion:@escaping (_ result:Bool)->Void)
    {
        slideModel.logout(completion: {
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
