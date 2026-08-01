//
//  CoreDataPreview.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import SwiftUI
import CoreData

@MainActor
struct CoreDataPreview<Content: View>: View {
    private let content: (CoreDataStack) -> Content
    private let coreDataStack: CoreDataStack
    private var context: NSManagedObjectContext {
        coreDataStack.context
    }
    
    init(
        _ coreDataStack: @escaping () -> CoreDataStack,
        @ViewBuilder content: @escaping (CoreDataStack) -> Content
    ) {
        let coreDataStack = coreDataStack()
        self.content = content
        self.coreDataStack = coreDataStack
    }
    
    var body: some View {
        content(coreDataStack)
            .environment(\.managedObjectContext, context)
            .environmentObject(coreDataStack)
    }
}

extension CoreDataPreview {
    init(@ViewBuilder content: @escaping (CoreDataStack) -> Content) {
        self.init(CoreDataStack.sample, content: content)
    }
}

@MainActor
extension CoreDataStack {
    static func insertSampleData(context: NSManagedObjectContext) {
        CDTodoItem.createPreview(in: context)
        try? context.save()
    }
}
