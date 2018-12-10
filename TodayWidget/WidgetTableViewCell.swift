//
//  WidgetTableViewCell.swift
//  TodayWidget
//
//  Created by Jackie on 12/4/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import CoreData


class WidgetTableViewCell: UITableViewCell {

    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var title: UILabel!
    
    
    @IBAction func taskCompleted(_ sender: Any) {
        completed = true
        statusButton.setImage(#imageLiteral(resourceName: "checked-custom"), for: .normal)
//        task.setDefaultsForCompletion() //Goes down a complicated rabit hole.
        /* This func goes on my GoalItem+CoreDataClass.swift
         public func setDefaultsForLocalCreate() {
         self.localUpdate = NSDate()
         self.completed = false
         self.completionDate = NSDate.init(timeIntervalSinceReferenceDate: 0)
         self.needsUpload = true
         self.pendingDeletion = false
         self.identifier = UUID().uuidString
         self.archived = false
         let defaultDeltaInHours: Int = Int( UserDefaults.standard.double(forKey: UserDefaults.Keys.dueHoursFromNow) )
         self.dueDate = (Date() + (defaultDeltaInHours).hours) as NSDate
         self.reminder = false
         self.reminderDate = dueDate
         self.title = NSLocalizedString("", comment:"")
         self.location = nil
         }

 */
        
        
        
        guard let managedContext = task.managedObjectContext else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            fatalError("Error during core data save in Widget: \(error.localizedDescription)")
        }
    }
    
    var task: GoalItem! {
        didSet {
            title.text = task.text
            completed = task.completed
            statusButton.isEnabled = true
        }
    }
    var completed = true
    var completedTasks = [String]() // save the task identifier. //Need to research this more in example app.

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        statusButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        statusButton.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    

}
