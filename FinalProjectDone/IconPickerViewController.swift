//
//  IconPickerViewController.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import Foundation

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    
    // MARK: - Properties
    
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
        "No Icon",
        "Business",
        "Computer",
        "Fun",
        "Self",
        "Sport"
    ]
    
    
    
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconName = icons[indexPath.row]
        
        cell.textLabel?.text = iconName
        cell.imageView?.image = UIImage(named: iconName)
        
        return cell
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let iconName = icons[indexPath.row]
        delegate?.iconPicker(self, didPick: iconName)
    }
}
