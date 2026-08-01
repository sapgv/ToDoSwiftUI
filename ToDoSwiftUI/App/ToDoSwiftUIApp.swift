//
//  ToDoSwiftUIApp.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import SwiftUI
import CoreData

@main
struct ToDoSwiftUIApp: App {
    @State private var coreDataStack = CoreDataStack.shared
    @State private var todoModel = TodoModel(
        fetchService: TodoFetchService(),
        storage: TodoStorage()
    )

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TodoListView()
            }
            .environment(\.managedObjectContext, coreDataStack.context)
            .environment(todoModel)
        }
    }
}
