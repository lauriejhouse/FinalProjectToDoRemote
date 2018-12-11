//
//  CoreDatastack.swift
//  TodayWidget
//
//  Created by Jackie on 12/4/18.
//  Copyright © 2018 Jackie Norstrom. All rights reserved.
//

//https://stackoverflow.com/questions/42360879/how-to-use-core-data-in-widget-today-extension
/*
 See CoreDataStack.swift in example finished app to see what to add as well as the link above. CoreData Stack is needed for Today Widget to work with CoreData.
 
 */
import Foundation
import CoreData

public class CoreDataStack {
    
    private let modelName: String
    private static var sharedInstance: CoreDataStack!
    
    private init(modelName: String) {
        self.modelName = modelName
        CoreDataStack.sharedInstance = self
    

    
}


}
