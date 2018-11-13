//
//  ViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class MainGoalsViewController: UITableViewController, NewGoalViewControllerDelegate {
    
    // MARK: - Properties
    
    let rowHeight: CGFloat = 75
    var managedContext: NSManagedObjectContext!
    var goalItems: [GoalItem]? = []
    var checkedItems: Int?
    
    @IBOutlet weak var taskButton: UIButton!
    
    
    
    
    
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            let ac = UIAlertController(title: "Delete?", message: "This will remove your goal as well as any of its tasks.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (delete) in
                
                guard let goalToDelete = self.goalItems?[indexPath.row] else { return }
                self.goalItems?.remove(at: indexPath.row)
                self.managedContext.delete(goalToDelete)
                self.save()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.selectNewGoal()
                
                
                
            }
            ac.addAction(cancelAction)
            ac.addAction(deleteAction)
            present(ac, animated: true, completion: nil)
            
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
                    } else {                                                    // If the goalItems array has nothing in it, then we show this below
                        vc.title = "Your Tasks Will Appear Here!"
                        vc.navigationItem.rightBarButtonItem?.isEnabled = false
                    }
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Custom Methods
    
    func configure(_ cell: UITableViewCell, with goal: GoalItem) {
        let textLabel = cell.viewWithTag(1000) as? UILabel
        let icon = cell.viewWithTag(10) as? UIImageView
        let tasksDoneLabel = cell.viewWithTag(5000) as? UILabel
        guard let tasksCount = goal.tasks?.count else { return }
        
        fetchCheckedItems(with: goal)
        
        if let checkedItems = checkedItems {
            if tasksCount == 0 {
                tasksDoneLabel?.text = "Select Goal To Add New Tasks!"
            } else if checkedItems == 0 {
                tasksDoneLabel?.text = "Get Started! \(tasksCount) To Go!"
            } else if checkedItems == tasksCount {
                tasksDoneLabel?.text = "All Tasks Completed!"
            } else {
                tasksDoneLabel?.text = "\(checkedItems) / \(tasksCount) Completed"
            }
        }
        
        
        textLabel?.text = goal.text!
        icon?.image = UIImage(named: goal.iconName!)
    }
    
    func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func fetch() {
        let request = NSFetchRequest<GoalItem>(entityName: "GoalItem")
        
        do {
            let results = try managedContext.fetch(request)
            goalItems?.append(contentsOf: results)
        } catch let error as NSError {
            print(error)
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


