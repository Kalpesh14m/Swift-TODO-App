//  SlideMenuPresenter.swift
//Purpose:
    //1.Used for Pass data to model for validation.


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
