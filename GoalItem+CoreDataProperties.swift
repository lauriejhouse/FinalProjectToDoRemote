//
//  GoalItem+CoreDataProperties.swift
//  
//
//  Created by Jackie on 12/4/18.
//
//

import Foundation
import CoreData

//https://www.raywenderlich.com/2076-video-tutorial-ios-app-extensions-part-7-today-extensions-core-data
//https://www.whatmatrix.com/portal/a-guide-to-cloudkit-how-to-sync-user-data-across-ios-devices/


extension GoalItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalItem> {
        return NSFetchRequest<GoalItem>(entityName: "GoalItem")
    }

    @NSManaged public var iconName: String?
    @NSManaged public var percentageComplete: Int32
    @NSManaged public var text: String?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var completed: Bool
    @NSManaged public var completionDate: NSDate?
    @NSManaged public var tasks: NSOrderedSet?

}

// MARK: Generated accessors for tasks
extension GoalItem {

    @objc(insertObject:inTasksAtIndex:)
    @NSManaged public func insertIntoTasks(_ value: TaskItem, at idx: Int)

    @objc(removeObjectFromTasksAtIndex:)
    @NSManaged public func removeFromTasks(at idx: Int)

    @objc(insertTasks:atIndexes:)
    @NSManaged public func insertIntoTasks(_ values: [TaskItem], at indexes: NSIndexSet)

    @objc(removeTasksAtIndexes:)
    @NSManaged public func removeFromTasks(at indexes: NSIndexSet)

    @objc(replaceObjectInTasksAtIndex:withObject:)
    @NSManaged public func replaceTasks(at idx: Int, with value: TaskItem)

    @objc(replaceTasksAtIndexes:withTasks:)
    @NSManaged public func replaceTasks(at indexes: NSIndexSet, with values: [TaskItem])

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskItem)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskItem)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSOrderedSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSOrderedSet)

}
