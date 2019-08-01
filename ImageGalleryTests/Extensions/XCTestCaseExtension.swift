//
//  XCTestCaseExtension.swift
//  ImageGalleryTests
//
//  Created by Kobayashi on 01/08/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import XCTest
import CoreData

extension XCTestCase {
    
    func setupCoreDataStack(with name: String, `in` bundle: Bundle) -> NSManagedObjectContext {
        // Fetch Model URL
        let modelURL = bundle.url(forResource: name, withExtension: "momd")!
        
        // Initialize Managed Object Model
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        
        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        // Add Persistent Store
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
}
