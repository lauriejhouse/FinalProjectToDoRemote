//
//  CoreDataManager.swift
//  FinalProjectDone
//
//  Created by Jackie on 12/10/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import Foundation
import CoreData
import Seam3

struct CoreDataManager {
    
    static var shared = CoreDataManager()
    var managedContext: NSManagedObjectContext!
    var smStore: SMStore!
    
    func save() -> Bool {
        do {
            try managedContext.save()
            return true
        } catch {
            print("Could not save. \(error.localizedDescription)")
            return false
        }
    }
    
    func addGoal(with name: String) -> GoalItem? {
        let entity = NSEntityDescription.entity(forEntityName: "GoalItem", in: managedContext)!
        let goal = NSManagedObject(entity: entity, insertInto: managedContext) as! GoalItem
        
        //or goal.name = name
        goal.setValue(name, forKeyPath: "text")
        
        return self.save() ? goal : nil
    }
    
    func addTask(to goal: GoalItem, with name: String) -> TaskItem? {
        
        let entity = NSEntityDescription.entity(forEntityName: "TaskItem", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext) as! TaskItem
        task.setValue(name, forKeyPath: "name")
        
        goal.addToTasks(task)
        
        return self.save() ? task : nil
    }
    
    func getAllGoals() -> [GoalItem]? {
        
        let goalsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GoalItem")
        
        do {
            let goals = try managedContext.fetch(goalsFetch) as! [GoalItem]
            return goals
        } catch {
            print("Failed to fetch goals: \(error)")
            return nil
        }
    }
}

