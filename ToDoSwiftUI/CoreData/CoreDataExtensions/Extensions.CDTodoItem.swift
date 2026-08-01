//
//  Extensions.CDTodoItem.swift
//  TodoViper
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import CoreData
import Foundation

extension CDTodoItem {
    static func searchPredicate(title: String) -> NSPredicate? {
        title.isEmpty ? nil : NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(CDTodoItem.title), title)
    }
    
    static var listSort: [SortDescriptor<CDTodoItem>] {
        [
            SortDescriptor(\.dateCreated, order: .reverse),
            SortDescriptor(\.title, order: .forward),
        ]
    }
}

// MARK: - CoreDataInsertProtocol

extension CDTodoItem: CoreDataInsertProtocol {
    func fill(model: TodoItem) {
        self.uuid = model.uuid
        self.dateCreated = model.dateCreated
        self.title = model.title
        self.descriptionText = model.descriptionText
        self.completed = model.completed
    }
}

// MARK: - Preview

extension CDTodoItem {
    static var items: [CDTodoItem] = []
    static var item1: CDTodoItem!
    
    private static func createObject(
        title: String,
        descriptionText: String,
        completed: Bool,
        context: NSManagedObjectContext
    ) -> CDTodoItem {
        let item = CDTodoItem(context: context)
        item.uuid = UUID()
        item.dateCreated = Date().startOfDay
        item.title = title
        item.descriptionText = descriptionText
        item.completed = completed
        return item
    }
    
    static func createPreview(in context: NSManagedObjectContext) {
        for i in 1...21 {
            let item = createObject(title: "Title \(i)", descriptionText: "Description \(i)", completed: Bool.random(), context: context)
            items.append(item)
        }
        self.item1 = items.first!
    }

}
