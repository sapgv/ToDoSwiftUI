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
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
