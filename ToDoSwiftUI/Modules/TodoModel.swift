//
//  TodoModel.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import Foundation
import CoreData
import Observation

@Observable
final class TodoModel {
    private let fetchService: TodoFetchServiceProtocol
    private let storage: TodoStorageProtocol
    
    init(
        fetchService: TodoFetchServiceProtocol,
        storage: TodoStorageProtocol
    ) {
        self.fetchService = fetchService
        self.storage = storage
    }
    
    func loadItems() async throws {
        let count = try await storage.fetchCount()
        guard count == 0 else { return }
        let items = try await fetchService.fetch()
        try await storage.insertItems(items: items)
    }
    
    func insertItems(_ items: [TodoItem]) async throws {
        try await storage.insertItems(items: items)
    }
    
    func saveItem(_ item: TodoItem) async throws {
        try await storage.saveItem(item)
    }
    
    func deleteItem(_ item: CDTodoItem) async throws {
        try await storage.deleteItem(item.objectID)
    }
    
    func update(_ item: CDTodoItem, value: Bool) async throws {
        try await storage.complete(item.objectID, value: value)
    }
}
