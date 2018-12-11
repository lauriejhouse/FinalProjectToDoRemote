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
import Seam3

protocol NewGoalViewControllerDelegate: class {
    func newGoalViewControllerDidCancel(_ controller: NewGoalViewController)
    func newGoalViewController(_ controller: NewGoalViewController, didFinishAdding goal: GoalItem)
    func newGoalViewController(_ controller: NewGoalViewController, didFinishEditing goal: GoalItem)
}

class NewGoalViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    // MARK: - Properties
    
    //https://github.com/paulw11/Seam3/blob/master/Sources/Classes/NSManagedObject%2BCKRecord.swift - NSManagedObject+CKRecord.swift
    
    
//    var recordZone: CKRecordZone!
    
    
  //Going to need custom zone?
    
//    let recordZone = CKRecordZone.ID(zoneName: "_defaultZone", ownerName: "_6c6777e3b8e64bf08735b7eddc6cf782")
//    let ckRecordID = CKRecord.ID(recordName: recordIDString, zoneID: recordZone)
//    let ckRecord = CKRecord(recordType: myRecordType, recordID: ckRecordID)

    //Old cloudkit stuff before seam3import
//    let container = CKContainer.default()
//    var currentRecord: CKRecord?
//    lazy var publicDB: CKDatabase! = {
//        let DB = self.container.publicCloudDatabase
//        return DB
//    }()
    
    lazy var managedContext = {
        return CoreDataManager.shared.managedContext!
    }()
    
    
    //why do i need a delegate? what is a delegate
    weak var delegate: NewGoalViewControllerDelegate?
    var goalToEdit: GoalItem?
    var goals = [GoalItem]()

    
    let icons = ["No Icon", "Sport", "Self", "Business", "Computer", "Fun"]
    var placeholderGoals = ["Learn Programming", "Learn Piano", "Build Rome", "Become Enlightened", "Breathe Underwater", "Turn Back Time", "Run A Marathon", "Read 10 Books", "Quit Job", "Deactivate Facebook"]
    
    
    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
   
    // MARK: - BPs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        publicDB?.save(recordZone!,
//                       completionHandler: {(recordzone, error) in
//                        if (error != nil) {
//                            self.notifyUser("Record Zone Error",
//                                            message: "Failed to create custom record zone.")
//                        } else {
//                            print("Saved record zone")
//                        }
//        })
        
        CloudKitManager.shared.triggerSyncWithCloudKit()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: SMStoreNotification.SyncDidFinish), object: nil, queue: nil) { notification in
            
            if notification.userInfo != nil {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.smStore?.triggerSync(complete: true)
            }
            
            self.managedContext.refreshAllObjects()
            
            DispatchQueue.main.async {
                self.goals = CoreDataManager.shared.getAllGoals() ?? []
                self.tableView.reloadData()
            }
        }
        
        //Think I still need to keep this here for editing/listing goals.
        if let goal = goalToEdit {
            title = "Edit Goal"
            goalTextField.text = goal.text
            doneBtn.isEnabled = true
            iconLabel.text = goal.iconName
            imageViewIcon.image = UIImage(named: goal.iconName!)
        } else {
            let randomGoals = placeholderGoals.randomItem()
            goalTextField.placeholder = "\(randomGoals!)..."
            let random = icons.randomItem()
            imageViewIcon.image = UIImage(named: random!)
            iconLabel.text = random
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        goalTextField.becomeFirstResponder()
        self.goals = CoreDataManager.shared.getAllGoals() ?? []

    }
    
    
    //Old CLoudkit
//    func notifyUser(_ title: String, message: String) -> Void
//    {
//        let alert = UIAlertController(title: title,
//                                      message: message,
//                                      preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "OK",
//                                         style: .cancel, handler: nil)
//
//        alert.addAction(cancelAction)
//        self.present(alert, animated: true,
//                     completion: nil)
//    }
    
    
    
    // MARK: - Action Methods
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.newGoalViewControllerDidCancel(self)
    }
    
    //need to make this save to icloud when pressed
    //But done button also needs to save locally to the table and do all the things it did before.
    
    @IBAction func done(_ sender: Any) {
        
        //"OLD" default way of saving goals to table. Not using cloudkit, only coredata.
        if let goal = goalToEdit {
            goal.text = goalTextField.text!
            goal.iconName = iconLabel.text!
            delegate?.newGoalViewController(self, didFinishEditing: goal)
        } else {
                        let goal = NSEntityDescription.insertNewObject(forEntityName: "GoalItem", into: managedContext) as! GoalItem
                        goal.text = goalTextField.text!
                        goal.iconName = iconLabel.text
                        delegate?.newGoalViewController(self, didFinishAdding: goal)
        }
        
        //change done button to alert action?
        let alertController = UIAlertController(title: "Add Goal", message: nil , preferredStyle: .actionSheet)

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert in
            let field = self.goalTextField
            guard let name = field?.text else { return }

            //original
//            let field = alertController.textFields![0] as UITextField
//            guard let name = field.text else { return }
            
            guard let _ = CoreDataManager.shared.addGoal(with: name) else { return }
            self.goals = CoreDataManager.shared.getAllGoals() ?? []
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    //Trying to save with CloudKit. Commenting out to get it to mostly work.
//        let myRecord = CKRecord(recordType: "Goal",zoneID: (recordZone?.zoneID)!)
//
//        myRecord.setObject(goalTextField.text as CKRecordValue?,
//                           forKey: "goalDescription")
//
//
//        let modifyRecordsOperation = CKModifyRecordsOperation(
//            recordsToSave: [myRecord],
//            recordIDsToDelete: nil)
//        //Depreciated in iOS11
////        modifyRecordsOperation.timeoutIntervalForRequest = 10
////        modifyRecordsOperation.timeoutIntervalForResource = 10
//
//        modifyRecordsOperation.modifyRecordsCompletionBlock =
//            { records, recordIDs, error in
//                if let err = error {
//                    self.notifyUser("Save Error", message:
//                        err.localizedDescription)
//                } else {
//                    DispatchQueue.main.async {
//                        self.notifyUser("Success",
//                                        message: "Record saved successfully")
//                    }
//                    self.currentRecord = myRecord
//                }
//        }
//        publicDB?.add(modifyRecordsOperation)
        
        
        
        
    }  //this bracket ends the done button function

        

    
    
    
    
    
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
        
        doneBtn.isEnabled = newText.length > 0
        
        return true
        
    }
    
    
    
    
    
    // MARK: - Icon Picker Delegate
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        imageViewIcon.image = UIImage(named: iconName)
        iconLabel.text = iconName
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
