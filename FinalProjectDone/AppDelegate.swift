//
//  AppDelegate.swift
//  FinalProjectDone
//
//  Created by Jackie Norstrom on 9/21/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Seam3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var smStore: SMStore!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let vcNav = splitViewController.viewControllers.first as! UINavigationController
        let vc = vcNav.topViewController as! MainGoalsViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        navigationController.topViewController?.navigationItem.rightBarButtonItem?.isEnabled = false
        splitViewController.delegate = self
        vc.managedContext = persistentContainer.viewContext
        
        //For Seam3 CoreData+CloudKit
        self.smStore = persistentContainer.persistentStoreCoordinator.persistentStores.first as? SMStore
        
        CoreDataManager.shared.managedContext = self.persistentContainer.viewContext
        CoreDataManager.shared.smStore = self.smStore
        CloudKitManager.shared.smStore = self.smStore
        
        return true
        
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else {  return false  }
        guard let secondaryAsTaskViewController = secondaryAsNavController.topViewController as? TaskViewController else { return false }
        if secondaryAsTaskViewController.goalItem?.tasks == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//
//        SMStore.registerStoreClass()
//
//
//
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "FinalProjectDone")
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//
//
//
//
//
//
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        SMStore.registerStoreClass()
        
        let container = NSPersistentContainer(name: "FinalProjectDone")
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let applicationDocumentsDirectory = urls.last {
            
            let url = applicationDocumentsDirectory.appendingPathComponent("FinalProjectDone.sqlite")
            
            let storeDescription = NSPersistentStoreDescription(url: url)
            
            storeDescription.type = SMStore.type
            
            container.persistentStoreDescriptions=[storeDescription]
            
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }
        
        fatalError("Unable to access documents directory")
        
    }()
    
    
    
    

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

