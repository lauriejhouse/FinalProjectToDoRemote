//
//  TaskItem+CoreDataProperties.swift
//  
//
//  Created by Jackie Norstrom on 12/12/18.
//
//

import Foundation
import CoreData


extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var isChecked: Bool
    @NSManaged public var text: String?
    @NSManaged public var goal: GoalItem?

}
