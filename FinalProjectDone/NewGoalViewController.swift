//
//  NewGoalViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import Foundation
import CoreData

protocol NewGoalViewControllerDelegate: class {
    func newGoalViewControllerDidCancel(_ controller: NewGoalViewController)
    func newGoalViewController(_ controller: NewGoalViewController, didFinishAdding goal: GoalItem)
    func newGoalViewController(_ controller: NewGoalViewController, didFinishEditing goal: GoalItem)
}

class NewGoalViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconNameLabel: UILabel!
    
    var managedContext: NSManagedObjectContext!
    
    weak var delegate: NewGoalViewControllerDelegate?
    var goalToEdit: GoalItem?
    
    let icons = ["No Icon", "Sport", "Self", "Business", "Computer", "Fun"]
    var placeholderGoals = ["Learn Programming", "Learn Piano", "Build Rome", "Become Enlightened", "Breathe Underwater", "Turn Back Time", "Run A Marathon", "Read 10 Books", "Quit Job", "Deactivate Facebook"]
    
    
    
    
    
    
    
    // MARK: - Action Methods
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.newGoalViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let goal = goalToEdit {
            goal.text = textField.text!
            goal.iconName = iconNameLabel.text!
            delegate?.newGoalViewController(self, didFinishEditing: goal)
        } else {
            let goal = NSEntityDescription.insertNewObject(forEntityName: "GoalItem", into: managedContext) as! GoalItem
            goal.text = textField.text!
            goal.iconName = iconNameLabel.text
            delegate?.newGoalViewController(self, didFinishAdding: goal)
        }
        
    }
    
    
    
    
    
    // MARK: - BPs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let goal = goalToEdit {
            title = "Edit Goal"
            textField.text = goal.text
            doneButton.isEnabled = true
            iconNameLabel.text = goal.iconName
//            iconImageView.image = UIImage(named: goal.iconName!)
        } else {
            let randomGoals = placeholderGoals.randomItem()
            textField.placeholder = "\(randomGoals!)..."
            let random = icons.randomItem()
//            iconImageView.image = UIImage(named: random!)
            iconNameLabel.text = random
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 && indexPath.row == 2 {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    
    
    
    // MARK: - Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneButton.isEnabled = newText.length > 0
        
        return true
        
    }
    
    
    
    
    
    // MARK: - Icon Picker Delegate
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
//        iconImageView.image = UIImage(named: iconName)
        iconNameLabel.text = iconName
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let vc = segue.destination as! IconPickerViewController
            vc.delegate = self
        }
    }
    
    
    
    
}

public extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
