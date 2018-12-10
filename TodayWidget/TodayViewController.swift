//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Jackie on 12/4/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

//https://stackoverflow.com/questions/42360879/how-to-use-core-data-in-widget-today-extension


import UIKit
import NotificationCenter
import CoreData


class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var tableView: UITableView!
    
    var managedContext: NSManagedObjectContext!

 var todayGoal = [GoalItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        tableView.dataSource = self
        tableView.delegate = self
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}


// MARK: - TableView Datasource and Delegate
extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayGoal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetTableViewCell", for: indexPath) as! WidgetTableViewCell
        let task = todayGoal[indexPath.row]
        cell.task = task
        return cell
    }
    
}
