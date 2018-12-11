//
//  CloudKitManager.swift
//  FinalProjectDone
//
//  Created by Jackie on 12/11/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import Foundation
import CloudKit
import Seam3

struct CloudKitManager {
    
    static var shared = CloudKitManager()
    var smStore: SMStore!
    
    // this is how you can get the goals manually
    //    func getAllGoals() {
    //
    //        let query = CKQuery(recordType: "Goal", predicate: NSPredicate(value: true))
    //        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
    //            records?.forEach({ (record) in
    //
    //                // System Field from property
    //                let recordName = record.recordID.recordName
    //                print("System Field, recordName: \(recordName)")
    //
    //                // Custom Field from key path (eg: name)
    //                let name = record.value(forKey: "name")
    //                print("Custom Field, name: \(name ?? "")")
    //            })
    //        }
    //    }
    
    func triggerSyncWithCloudKit() {
        
        self.smStore?.verifyCloudKitConnectionAndUser() { (status, user, error) in
            guard status == .available, error == nil else {
                NSLog("Unable to verify CloudKit Connection \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let currentUser = user else {
                NSLog("No current CloudKit user")
                return
            }
            
            var completeSync = false
            
            let previousUser = UserDefaults.standard.string(forKey: "CloudKitUser")
            if  previousUser != currentUser {
                do {
                    print("New user")
                    try self.smStore?.resetBackingStore()
                    completeSync = true
                } catch {
                    NSLog("Error resetting backing store - \(error.localizedDescription)")
                    return
                }
            }
            
            UserDefaults.standard.set(currentUser, forKey:"CloudKitUser")
            
            self.smStore?.triggerSync(complete: completeSync)
        }
    }
}
