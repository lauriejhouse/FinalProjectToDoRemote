//
//  NewTaskViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import CoreData

protocol NewTaskViewControllerDelegate: class {
    func newTaskViewControllerDidCancel(_ controller: NewTaskViewController)
    func newTaskViewController(_ controller: NewTaskViewController, didFinishAdding task: TaskItem)
}

class NewTaskViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var managedContext: NSManagedObjectContext!
    
    weak var delegate: NewTaskViewControllerDelegate?
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textField.becomeFirstResponder()
    }
    
    
    
    
    
    // MARK: - Action Methods
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.newTaskViewControllerDidCancel(self)
        print("Registered")
    }
    
    
    @IBAction func done(_ sender: Any) {
        let task = NSEntityDescription.insertNewObject(forEntityName: "TaskItem", into: managedContext) as! TaskItem
        task.text = textField.text!
        task.isChecked = false
        delegate?.newTaskViewController(self, didFinishAdding: task)
        print("done")
    }
    
    
    
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
}
