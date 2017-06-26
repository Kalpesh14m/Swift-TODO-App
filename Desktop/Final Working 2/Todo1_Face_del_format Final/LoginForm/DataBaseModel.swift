//
//  DataBaseModel.swift
//  Title :- Todo1.4
//
//  Created by BridgeLabz Solutions LLP  on 4/10/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation
import CoreData

class DataBaseModels
{
    class func removeCoreData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotes")
    
        do
        {
            currentUserData = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            for data in currentUserData
            {
                context.delete(data)
                myData.removeAll()
                myArchData.removeAll()
                myRemdData.removeAll()
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    
    class func updateData(completion:(_ isDone:Bool)->Void)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotes")
        
        do
        {
            currentUserData = try context.fetch(fetchRequest) as! [NSManagedObject]
            
//            print("data",currentUserData.count)
//            
//            for i in 0..<currentUserData.count
//            {
//                let dict = ["note":currentUserData[i].value(forKey: "note") as? String,"title":currentUserData[i].value(forKey: "title") as? String,"reminder":currentUserData[i].value(forKey: "reminder") as? String,"rec":currentUserData[i].value(forKey: "key") as? String]
//                
//                myData.append(dict as! [String : String])
//                
//            }
            
            completion(true)
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    
    class func newUpdateData(completion:(_ isDone:Bool)->Void)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotes")
        
        fetchRequest.predicate = NSPredicate(format: "%K = %@","username","false")
        
        do
        {
            currentUserData = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            completion(true)
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
}
