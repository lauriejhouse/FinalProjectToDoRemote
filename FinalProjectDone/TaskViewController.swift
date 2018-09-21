//
//  TaskViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class TaskViewController: UITableViewController, NewTaskViewControllerDelegate {
    
    var goalItem: GoalItem?
    var managedContext: NSManagedObjectContext!

    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let goalItem = goalItem {
            if let tasks = goalItem.tasks {
                return tasks.count
            }
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        guard let task = goalItem?.tasks?[indexPath.row] as? TaskItem  else { return cell }
        configureText(for: cell, with: task)
        configureCheckmark(for: cell, with: task)
        return cell
    }
    
    
    
    
    
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if let task = goalItem?.tasks?[indexPath.row] as? TaskItem {
                task.toggleChecked()
                save()
                configureCheckmark(for: cell, with: task)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let taskToDelete = self.goalItem?.tasks?[indexPath.row] as? TaskItem else { return }
        self.managedContext.delete(taskToDelete)
        self.save()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    
    
    
    
    
    
    // MARK: - Custom Methods
    
    func configureCheckmark(for cell: UITableViewCell, with task: TaskItem) {
        
        let imageView = cell.viewWithTag(3000) as! UIImageView
        
        if task.isChecked != true {
            imageView.image = #imageLiteral(resourceName: "No Icon")
        } else {
            imageView.image = #imageLiteral(resourceName: "checked-3")
        }
    }
    
    func configureText(for cell: UITableViewCell, with task: TaskItem) {
        let taskLabel = cell.viewWithTag(2000) as! UILabel
        taskLabel.text = task.text
    }
    
    func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - Delegate
    
    func newTaskViewControllerDidCancel(_ controller: NewTaskViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func newTaskViewController(_ controller: NewTaskViewController, didFinishAdding task: TaskItem) {
        if let goalItem = goalItem, let tasks = goalItem.tasks?.mutableCopy() as? NSMutableOrderedSet {
            
            let newRowIndex = tasks.count
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            tasks.add(task)
            goalItem.tasks = tasks
            
            tableView.insertRows(at: [indexPath], with: .automatic)
            save()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTask" {
            let nav = segue.destination as! UINavigationController
            let newTaskVc = nav.topViewController as! NewTaskViewController
            newTaskVc.delegate = self
            newTaskVc.managedContext = managedContext
        }
    }
}

