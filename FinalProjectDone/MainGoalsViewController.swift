//
//  ViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//



//Things left to do:
/*
 
 Achievement 1
 * The app should contain a list of tasks, which can be implemented using either a table view or a collection view. Users should be able to move and delete items within the list.
 *
 * The app should be available on a repository on GitHub, and you should use version control regularly when working on the app.
 
 Achievement 2
 * The app should use assets catalogs to show images and icons in the app. Optionally, you could show different images for iPhones and iPads.
 * The app UI should be fully adaptive to the screen size and device type that it's running on.
 * The app should use a split view to view the list of tasks and task details side-by-side when running on an iPad.
 
 Achievement 3
 * The app should use Core Data to persist the tasks users enter so that they will be saved when the app is closed and displayed again in the next session.

 
 Removed pods.
 */

import UIKit
import Foundation
import CoreData


class MainGoalsViewController: UITableViewController, NewGoalViewControllerDelegate {
    


    
    // MARK: - Properties
    
    let rowHeight: CGFloat = 75
    lazy var managedContext = {
        return CoreDataManager.shared.managedContext!
    }()
    
    var goalItems: [GoalItem]? = []
    var checkedItems: Int?
    


    // MARK: - BPs
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.rowHeight = rowHeight
        fetch()
        selectNewGoal()
     
        
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    
    
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let goalItems = goalItems {
            return goalItems.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath  ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
        if let goalItems = goalItems {
            let goalItem = goalItems[indexPath.row]
            configure(cell, with: goalItem)
        }
        
        if let button = cell.viewWithTag(999) as? UIButton {
            button.tag = indexPath.row
        }
        
        return cell
    }
    
    
    
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //To move goal items. Being replaced by cocoapod. - not in the mid checkpoint file
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.goalItems?[sourceIndexPath.row]
        goalItems?.remove(at: sourceIndexPath.row)
        goalItems?.insert(movedObject!, at: destinationIndexPath.row)
//        do {
//            try self.managedContext.save()
//        } catch {
//            print("Rows could not be saved")
//        }

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            let deleteAlertController = UIAlertController(title: "Delete?", message: "This will remove your goal and tasks.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (delete) in
                
                guard let goalToDelete = self.goalItems?[indexPath.row] else { return }
                self.goalItems?.remove(at: indexPath.row)
                self.managedContext.delete(goalToDelete)
                self.save()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.selectNewGoal()
                
            }
            
            deleteAlertController.addAction(cancelAction)
            deleteAlertController.addAction(deleteAction)
            present(deleteAlertController, animated: true, completion: nil)
            
        }
    }
    
   
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
    }
    
    
    
    
    
    
    
    // MARK: - TextField Delegate
    
    func newGoalViewControllerDidCancel(_ controller: NewGoalViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func newGoalViewController(_ controller: NewGoalViewController, didFinishAdding goal: GoalItem) {
        guard let newRowIndex = goalItems?.count else { return }
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        goalItems?.append(goal)
        tableView.insertRows(at: [indexPath], with: .automatic)
        dismiss(animated: true, completion: nil)
        save()
    }
    
    func newGoalViewController(_ controller: NewGoalViewController, didFinishEditing goal: GoalItem) {
        if let index = goalItems?.index(of: goal) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configure(cell, with: goal)
            }
        }
        save()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddGoal" {
            let nav = segue.destination as! UINavigationController
            let goalVC = nav.topViewController as! NewGoalViewController
            goalVC.delegate = self
            goalVC.managedContext = managedContext
            
        } else if segue.identifier == "EditGoal" {
            let nav = segue.destination as! UINavigationController
            let goalVC = nav.topViewController as! NewGoalViewController
            goalVC.delegate = self
            
            if let button = sender as? UIButton {
                goalVC.goalToEdit = goalItems?[button.tag]
            }
        } else if segue.identifier == "ShowGoal" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let nav = segue.destination as! UINavigationController
                let vc = nav.topViewController as! TaskViewController
                vc.managedContext = managedContext
                if let goalItems = goalItems {
                    if !goalItems.isEmpty {
                        let item = goalItems[indexPath.row]
                        vc.goalItem = item
                        vc.title = item.text
                    } else {
                        // If the goalItems array has nothing in it, then we show this below
                        vc.title = "Your Tasks Will Appear Here."
                        vc.navigationItem.rightBarButtonItem?.isEnabled = false
                    }
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Custom Methods
    //Way to do this without using tags.
    func configure(_ cell: UITableViewCell, with goal: GoalItem) {
        let textLabel = cell.viewWithTag(1000) as? UILabel
        let icon = cell.viewWithTag(10) as? UIImageView
        let tasksDoneLabel = cell.viewWithTag(5000) as? UILabel
        guard let tasksCount = goal.tasks?.count else { return }
        
        fetchCheckedItems(with: goal)
        
        if let checkedItems = checkedItems {
            if tasksCount == 0 {
                tasksDoneLabel?.text = "Select Goal To Add New Tasks"
            } else if checkedItems == 0 {
                tasksDoneLabel?.text = " \(tasksCount) To Complete"
            } else if checkedItems == tasksCount {
                tasksDoneLabel?.text = "All Tasks Completed"
            } else {
                tasksDoneLabel?.text = "\(checkedItems) of \(tasksCount) Completed"
            }
        }
        
        
        textLabel?.text = goal.text!
        icon?.image = UIImage(named: goal.iconName!)
    }
    
    
    //These may already be in the coredata manager file
    //Crashes here because I already have it running somewhere else? Get all goals?
    func save() -> Bool {
        
        //orignal save method
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print(error)
//        }
        
        //commented out because i got thread 1 signal sgabrt. 
//        let _ =  CoreDataManager.shared.save()
        do {
            try managedContext.save()
            return true
        } catch {
            print("Could not save. \(error.localizedDescription)")
            return false
        }

    }
    
    
// Old Fetch
//    func fetch() {
////        let request = NSFetchRequest<GoalItem>(entityName: "GoalItem")
////
////        do {
////            let results = try managedContext.fetch(request)
////            goalItems?.append(contentsOf: results)
////        } catch let error as NSError {
////            print(error)
////        }
//
//
//    }
    
    
    func fetch() -> [GoalItem]? {
    
    let goalsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GoalItem")
    
    do {
    let goals = try managedContext.fetch(goalsFetch) as! [GoalItem]
    return goals
    } catch {
    print("Failed to fetch goals: \(error)")
    return nil
        }
    }

    
    
    func fetchCheckedItems(with goal: GoalItem) {
        let request = NSFetchRequest<TaskItem>(entityName: "TaskItem")
        request.predicate = NSPredicate(format: "goal == %@ AND isChecked == %@ ", goal, NSNumber(booleanLiteral: true))
        
        do {
            let results = try managedContext.fetch(request)
            checkedItems = results.count
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func selectNewGoal() {
        let initialIndexPath = IndexPath(row: 0, section: 0)
        if UIDevice.current.userInterfaceIdiom == .pad  {
            tableView.selectRow(at: initialIndexPath, animated: true, scrollPosition:UITableView.ScrollPosition.none)
            self.performSegue(withIdentifier: "ShowGoal", sender: initialIndexPath)
            tableView.deselectRow(at: initialIndexPath, animated: true)
        }
    }
}



extension MainGoalsViewController: TableViewDraggerDataSource, TableViewDraggerDelegate {
    func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        let movedObject = self.goalItems?[indexPath.row]
        goalItems?.remove(at: indexPath.row)
        goalItems?.insert(movedObject!, at: newIndexPath.row)
        
        tableView.moveRow(at: indexPath, to: newIndexPath)
        
        return true
    }
}


//Try 1 of making podfile work

//extension MainGoalsViewController: TableViewDraggerDataSource, TableViewDraggerDelegate {
//    func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
//        let movedObject = self.goalItems?[indexPath.row]
//                goalItems?.remove(at: indexPath.row)
//                goalItems?.insert(movedObject!, at: newIndexPath.row)
//
//        tableView.moveRow(at: indexPath, to: newIndexPath)
//
//        return true
//    }
//
//    func dragger(_ dragger: TableViewDragger, willBeginDraggingAt indexPath: IndexPath) {
//        if let tableView = dragger.tableView {
//            let scale = min(max(tableView.bounds.height / tableView.contentSize.height, 0.4), 1)
//            dragger.scrollVelocity = scale
//
//
//            UIView.animate(withDuration: 0.3) {
//                self.statusBarHidden = true
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//                if let tabBarHeight = self.tabBarController?.tabBar.bounds.height {
//                    self.tabBarController?.tabBar.frame.origin.y += tabBarHeight
//                }
//
//                self.tableViewHeightConstraint.constant = (tableView.bounds.height) / scale - tableView.bounds.height
//                tableView.transform = CGAffineTransform(scaleX: scale, y: scale)
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
//
//    func dragger(_ dragger: TableViewDragger, willEndDraggingAt indexPath: IndexPath) {
//
//        UIView.animate(withDuration: 0.3) {
//            self.statusBarHidden = false
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
//
//            if let tabBarHeight = self.tabBarController?.tabBar.bounds.height {
//                self.tabBarController?.tabBar.frame.origin.y -= tabBarHeight
//            }
//
//            self.tableViewHeightConstraint.constant = 0
//            if let tableView = dragger.tableView {
//                tableView.transform = CGAffineTransform.identity
//                self.view.layoutIfNeeded()
//                tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//            }
//        }
//    }
//}




//Part of cloudKit

//extension CKError {
//    public func isRecordNotFound() -> Bool {
//        return isZoneNotFound() || isUnknownItem()
//    }
//    public func isZoneNotFound() -> Bool {
//        return isSpecificErrorCode(code: .zoneNotFound)
//    }
//    public func isUnknownItem() -> Bool {
//        return isSpecificErrorCode(code: .unknownItem)
//    }
//    public func isConflict() -> Bool {
//        return isSpecificErrorCode(code: .serverRecordChanged)
//    }
//    public func isSpecificErrorCode(code: CKError.Code) -> Bool {
//        var match = false
//        if self.code == code {
//            match = true
//        }
//        else if self.code == .partialFailure {
//            // This is a multiple-issue error. Check the underlying array
//            // of errors to see if it contains a match for the error in question.
//            guard let errors = partialErrorsByItemID else {
//                return false
//            }
//            for (_, error) in errors {
//                if let cke = error as? CKError {
//                    if cke.code == code {
//                        match = true
//                        break
//                    }
//                }
//            }
//        }
//        return match
//    }
//    // ServerRecordChanged errors contain the CKRecord information
//    // for the change that failed, allowing the client to decide
//    // upon the best course of action in performing a merge.
//    public func getMergeRecords() -> (CKRecord?, CKRecord?) {
//        if code == .serverRecordChanged {
//            // This is the direct case of a simple serverRecordChanged Error.
//            return (clientRecord, serverRecord)
//        }
//        guard code == .partialFailure else {
//            return (nil, nil)
//        }
//        guard let errors = partialErrorsByItemID else {
//            return (nil, nil)
//        }
//        for (_, error) in errors {
//            if let cke = error as? CKError {
//                if cke.code == .serverRecordChanged {
//                    // This is the case of a serverRecordChanged Error
//                    // contained within a multi-error PartialFailure Error.
//                    return cke.getMergeRecords()
//                }
//            }
//        }
//        return (nil, nil)
//    }
//}
