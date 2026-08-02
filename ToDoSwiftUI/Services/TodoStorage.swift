//
//  TodoStorage.swift
//  TodoViper
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import Foundation
import CoreData

// sourcery: AutoMockable
protocol TodoStorageProtocol: AnyObject {
    func fetchCount() async throws -> Int
    func insertItems(items: [TodoItem]) async throws
    func saveItem(_ item: TodoItem) async throws
    func deleteItem(_ cdItemId: NSManagedObjectID) async throws
    func complete(_ cdItemId: NSManagedObjectID, value: Bool) async throws
}

final class TodoStorage: TodoStorageProtocol {
    func fetchCount() async throws -> Int {
        let count = try await CoreDataStack.shared.performAsyncTask { privateContext in
            let count = try CoreDataStack.shared.count(CDTodoItem.self, in: privateContext)
            return count
        }
        return count
    }
    
    func insertItems(items: [TodoItem]) async throws {
        try await CoreDataStack.shared.insert(CDTodoItem.self, items: items)
    }
    
    func saveItem(_ item: TodoItem) async throws {
        let uuids = [item.uuid].compactMap { $0 }
        let predicate = NSPredicate(format: "%K IN %@", #keyPath(CDTodoItem.uuid), uuids)
        let propertiesToUpdate: [AnyHashable: Any] = [
            #keyPath(CDTodoItem.uuid): item.uuid as Any,
            #keyPath(CDTodoItem.dateCreated): item.dateCreated,
            #keyPath(CDTodoItem.title): item.title,
            #keyPath(CDTodoItem.descriptionText): item.descriptionText,
            #keyPath(CDTodoItem.completed): item.completed,
        ]
        try await CoreDataStack.shared.update(CDTodoItem.self, predicate: predicate, propertiesToUpdate: propertiesToUpdate)
    }
    
    func deleteItem(_ cdItemId: NSManagedObjectID) async throws {
        let predicate = NSPredicate(format: "self == %@", cdItemId)
        try await CoreDataStack.shared.delete(CDTodoItem.self, predicate: predicate)
    }
    
    func complete(_ cdItemId: NSManagedObjectID, value: Bool) async throws {
        let predicate = NSPredicate(format: "self == %@", cdItemId)
        let propertiesToUpdate: [AnyHashable: Any] = [#keyPath(CDTodoItem.completed): value]
        try await CoreDataStack.shared.update(CDTodoItem.self, predicate: predicate, propertiesToUpdate: propertiesToUpdate)
    }
}
