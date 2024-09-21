//
//  PersistentContainerStorage.swift
//  Project
//
//  Created by Catarina Polakowsky on 07.08.2024.
//

import CoreData


enum EntityType: Codable {
    case favourite
    case basket
}

enum PersistantContainerStorage {
   static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Project")
        container.loadPersistentStores { _, error in
            print("Error to create persistent container: \(String(describing: error))")
        }
        return container
    }()
    
   static func saveContext() {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error to save context: \(nserror)")
            }
        }
    }
}
