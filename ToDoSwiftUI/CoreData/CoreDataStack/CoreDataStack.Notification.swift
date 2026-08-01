//
//  CoreDataStack.Notification.swift
//  SapgvCoreData
//
//  Created by Grigory Sapogov on 29.12.2025.
//

import CoreData

public extension Notification {
    var coreDataBatchChanges: [String: [NSManagedObjectID]]? {
        userInfo as? [String: [NSManagedObjectID]]
    }
    
    static func coreDataDidInsert(_ ids: [NSManagedObjectID]) -> Notification {
        let changes = [NSInsertedObjectIDsKey: ids]
        return Notification(name: .coreDataDidInsert, object: nil, userInfo: changes)
    }
    static func coreDataDidUpdate(_ ids: [NSManagedObjectID]) -> Notification {
        let changes = [NSUpdatedObjectIDsKey: ids]
        return Notification(name: .coreDataDidUpdate, object: nil, userInfo: changes)
    }
    static func coreDataDidDelete(_ ids: [NSManagedObjectID]) -> Notification {
        let changes = [NSDeletedObjectIDsKey: ids]
        return Notification(name: .coreDataDidDelete, object: nil, userInfo: changes)
    }
}

public extension Notification.Name {
    static let coreDataDidInsert = Notification.Name("coreDataDidInsert")
    static let coreDataDidUpdate = Notification.Name("coreDataDidUpdate")
    static let coreDataDidDelete = Notification.Name("coreDataDidDelete")
}
