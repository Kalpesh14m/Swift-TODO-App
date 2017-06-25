//  InboxPresenter.swift
//Purpose:
    //1.Used for Pass data to model for validation.

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
