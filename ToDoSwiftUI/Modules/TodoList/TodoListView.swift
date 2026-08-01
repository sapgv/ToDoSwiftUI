//
//  TodoListView.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import SwiftUI

struct TodoListView: View {
    @Environment(TodoModel.self) private var model
    
    @FetchRequest(sortDescriptors: CDTodoItem.listSort)
    private var items: FetchedResults<CDTodoItem>
    
    @State private var searchText: String = ""
    @State private var editItem: EditItem?
    @State private var error: LocalizedAlertError?
    
    var body: some View {
        List(items) { item in
            TodoListRow(item: item, action: itemAction)
                // alignmentGuide исправляет row separator
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        }
        .safeAreaInset(edge: .bottom) {
            TodoListBottomBar(itemCount: items.count) {
                editItem = .init(isNew: true, item: .init())
            }
        }
        .navigationTitle("Задачи")
        .listStyle(.plain)
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Поиск")
        .onChange(of: searchText) { filter(text: $1) }
        .task(loadItems)
        .alert(error: $error)
        .navigationDestination(item: $editItem) { item in
            TodoDetailView(item: item.item, isNew: item.isNew)
        }
    }
    
}

// MARK: - Private

private extension TodoListView {
    struct EditItem: Hashable {
        let isNew: Bool
        let item: TodoItem
    }
    
    func itemAction(_ action: TodoListRow.Action) {
        switch action {
        case let .edit(item):
            editItem = .some(.init(isNew: false, item: .init(cdTodoItem: item)))
        case .share:
            break
        case let .delete(item):
            Task {
                try await model.deleteItem(item)
            }
        case let .complete(item, value):
            Task {
                try await model.update(item, value: value)
            }
        }
    }
    
    func filter(text: String) {
        items.nsPredicate = CDTodoItem.searchPredicate(title: text)
    }
    
    func loadItems() async {
        do {
            try await model.loadItems()
        }
        catch {
            self.error = error.localizedAlertError
        }
    }
}

#Preview {
    CoreDataPreview { _ in
        NavigationStack {
            TodoListView()
        }
    }
}
