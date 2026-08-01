//
//  CoreDataStack.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import CoreData
import OSLog
import SwiftUI
import Combine

final class PersistentContainer: NSPersistentContainer, @unchecked Sendable {}

extension CoreDataStack {
    static let shared = CoreDataStack("ToDoSwiftUI")
    
    static let sample: () -> CoreDataStack = {
        let coreDataStack = CoreDataStack("ToDoSwiftUI", storeType: .inMemory)
        insertSampleData(context: coreDataStack.context)
        return coreDataStack
    }
}

final class CoreDataStack: ObservableObject, @unchecked Sendable {
    
    class var mergePolicy: NSMergePolicy { NSMergePolicy.mergeByPropertyObjectTrump }
    
    let modelName: String
    
    let storeType: StoreType
    
    let context: NSManagedObjectContext
    
    let persistentContainer: NSPersistentContainer
    
    private let logger: Logger = Logger()
    
    fileprivate init(
        _ modelName: String,
        bundle: Bundle? = nil,
        storeType: StoreType = .sql
    ) {
        self.modelName = modelName
        self.storeType = storeType
        
        let container: PersistentContainer
        var managedObjectModel: NSManagedObjectModel?
        if let modelURL = bundle?.url(forResource: modelName, withExtension: "momd"),
           let model = NSManagedObjectModel(contentsOf: modelURL) {
            managedObjectModel = model
        }
        if let managedObjectModel {
            container = PersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        }
        else {
            container = PersistentContainer(name: modelName)
        }
        
        let storeUrl = CoreDataStack.storeUrl(modelName: modelName, storeType: storeType)
        let storeDescription = NSPersistentStoreDescription(url: storeUrl)
        storeDescription.type = storeType.rawValue
        
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { [logger] persisterStoreDescription, error in
            guard error == nil else {
                logger.debug("\(CoreDataStackError.failureToInit.localizedDescription) \(error!.localizedDescription)")
                return
            }
            logger.debug("CoreData Initiated \(persisterStoreDescription)")
        }
        
        self.persistentContainer = container
        self.context = container.viewContext
        self.context.mergePolicy = Self.mergePolicy
        self.context.automaticallyMergesChangesFromParent = true
        self.setupNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CoreDataStack {
    static func storeUrl(modelName: String, storeType: StoreType) -> URL {
        switch storeType {
        case .sql:
            FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
                .appendingPathComponent("\(modelName).sqlite")
        case .inMemory:
            URL(fileURLWithPath: "/dev/null")
        }
    }
}

//MARK: - TASK

extension CoreDataStack {
    func performBackgroundTask(_ block: @escaping (_ privateContext: NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = Self.mergePolicy
            block(context)
        }
    }
    
    func performAsyncTask<T>(_ block: @escaping (_ privateContext: NSManagedObjectContext) throws -> T) async rethrows -> T {
        try await persistentContainer.performBackgroundTask { context in
            context.mergePolicy = Self.mergePolicy
            return try block(context)
        }
    }
}

//MARK: - Context

extension CoreDataStack {
    func createChildContext(from context: NSManagedObjectContext, concurrencyType: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
        let newContext = NSManagedObjectContext(concurrencyType: concurrencyType)
        newContext.automaticallyMergesChangesFromParent = true
        newContext.parent = context
        return newContext
    }
    
    func createContextFromCoordinator(concurrencyType: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
        let newContext = NSManagedObjectContext(concurrencyType: concurrencyType)
        newContext.automaticallyMergesChangesFromParent = true
        newContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        newContext.mergePolicy = Self.mergePolicy
        return newContext
    }
}

extension CoreDataStack {
    func count<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil, in context: NSManagedObjectContext) throws -> Int {
        do {
            let request = T.fetchRequest()
            request.predicate = predicate
            let count = try context.count(for: request)
            return count
        }
        catch {
            throw CoreDataStackError.failureToFetch
        }
    }
    
    func delete<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil) async throws {
        try await performAsyncTask { privateContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
            fetchRequest.predicate = predicate
            let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            request.resultType = .resultTypeObjectIDs
            
            if let result = try privateContext.execute(request) as? NSBatchDeleteResult,
               let objectIDs = result.result as? [NSManagedObjectID] {
                let notification = Notification.coreDataDidDelete(objectIDs)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(notification)
                }
            }
        }
    }
    
    func insert<T: CoreDataInsertProtocol>(_ type: T.Type, items: [T.Model]) async throws {
        guard !items.isEmpty else { return }
        try await CoreDataStack.shared.performAsyncTask { privateContext in
            var index = 0
            let total = items.count

            let request = NSBatchInsertRequest(entityName: CDTodoItem.entityName) { (managedObject: NSManagedObject) -> Bool in
                guard index < total else { return true }
                
                if let cdIitem = managedObject as? T {
                    let item = items[index]
                    cdIitem.fill(model: item)
                }
                
                index += 1
                return false
            }
            
            request.resultType = .objectIDs
            
            if let result = try privateContext.execute(request) as? NSBatchInsertResult,
               let objectIDs = result.result as? [NSManagedObjectID] {
                let notification = Notification.coreDataDidInsert(objectIDs)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(notification)
                }
            }
        }
    }
    
    func update<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil, propertiesToUpdate: [AnyHashable: Any]) async throws {
        try await CoreDataStack.shared.performAsyncTask { privateContext in
            let batchUpdateRequest = NSBatchUpdateRequest(entityName: T.entityName)
            batchUpdateRequest.predicate = predicate
            batchUpdateRequest.propertiesToUpdate = propertiesToUpdate
            batchUpdateRequest.resultType = .updatedObjectIDsResultType
            
            if let result = try privateContext.execute(batchUpdateRequest) as? NSBatchUpdateResult,
               let objectIDs = result.result as? [NSManagedObjectID] {
                let notification = Notification.coreDataDidUpdate(objectIDs)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(notification)
                }
            }
        }
    }
}

private extension CoreDataStack {
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataDidInsert), name: .coreDataDidInsert, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataDidUpdate), name: .coreDataDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(coreDataDidDelete), name: .coreDataDidDelete, object: nil)
    }
    
    @objc
    func coreDataDidInsert(notification: Notification) {
        guard let coreDataBatchChanges = notification.coreDataBatchChanges else { return }
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: coreDataBatchChanges, into: [context])
    }
    
    @objc
    func coreDataDidUpdate(notification: Notification) {
        guard let coreDataBatchChanges = notification.coreDataBatchChanges else { return }
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: coreDataBatchChanges, into: [context])
    }
    
    @objc
    func coreDataDidDelete(notification: Notification) {
        guard let coreDataBatchChanges = notification.coreDataBatchChanges else { return }
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: coreDataBatchChanges, into: [context])
    }
}
