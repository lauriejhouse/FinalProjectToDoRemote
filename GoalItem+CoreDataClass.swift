//
//  GoalItem+CoreDataClass.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import Foundation
import CoreData

@objc(GoalItem)
public class GoalItem: NSManagedObject {
    deinit {
        print("DEINITIALISED")
}
    
//    class func goalItemFromRecord (record: CKRecord, managedContext: NSManagedObjectContext) -> GoalItem {
//        let goal = NSEntityDescription.insertNewObject(forEntityName: "GoalItem", into: managedContext) as! GoalItem
//
//
//        //convert properties from CKrecord to goal.
//        //self.text = record.objectForKey/valueforkey("Task") for each property that needs to gt saved to goal items.
//        goal.text = record.object(forKey: "Task") as? String
//
//        return goal
//    }
    
    
//
//    public func setDefaultsForLocalCreate() {
////        self.localUpdate = NSDate()
//        self.completed = false
//        self.completionDate = NSDate.init(timeIntervalSinceReferenceDate: 0)
////        self.needsUpload = true
////        self.pendingDeletion = false
////        self.identifier = UUID().uuidString
////        self.archived = false
////        let defaultDeltaInHours: Int = Int( UserDefaults.standard.double(forKey: UserDefaults.Keys.dueHoursFromNow) )
//        self.dueDate = (Date()
////            + (defaultDeltaInHours).hours
//            ) as NSDate
////        self.reminder = false
////        self.reminderDate = dueDate
//        self.text = NSLocalizedString("", comment:"")
////        self.location = nil
//    }
    

}
//set object for key for saving.
