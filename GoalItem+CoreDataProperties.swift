//
//  GoalItem+CoreDataProperties.swift
//  
//
//  Created by Jackie Norstrom on 12/12/18.
//
//

import Foundation
import CoreData


extension GoalItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalItem> {
        return NSFetchRequest<GoalItem>(entityName: "GoalItem")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var iconName: String?
    @NSManaged public var percentageComplete: Int32
    @NSManaged public var text: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension GoalItem {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskItem)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskItem)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
