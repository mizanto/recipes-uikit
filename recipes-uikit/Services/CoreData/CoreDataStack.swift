//
//  CoreDataStack.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 5.09.2024.
//

import Foundation
import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Recipes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                AppLogger.shared.error("Failed to load persistent stores: \(error), \(error.userInfo)",
                                       category: .database)
            } else {
                AppLogger.shared.info("Persistent store loaded: \(storeDescription)", category: .database)
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                AppLogger.shared.info("Context saved successfully.", category: .database)
            } catch {
                let nserror = error as NSError
                AppLogger.shared.error("Failed to save context: \(nserror), \(nserror.userInfo)", category: .database)
            }
        } else {
            AppLogger.shared.info("No changes in context to save.", category: .database)
        }
    }
}
