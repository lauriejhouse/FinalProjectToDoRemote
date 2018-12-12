//
//  TaskItem+CoreDataClass.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//
//

import Foundation
import CoreData

@objc(TaskItem)
public class TaskItem: NSManagedObject {
   
    
    func toggleChecked() {
        isChecked = !isChecked
    }

    subscript(index: String) -> TaskItem? {
        guard let task = text?[index] else {
            return nil
        }
        return task
    }
    
    
}
