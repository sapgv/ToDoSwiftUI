//
//  TodoListRow.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import SwiftUI

struct TodoListRow: View {
    @Environment(\.dateFormatter) var dateFormatter: DateFormatter
    
    /// Нужно выносить в отдельный View чтобы проихсодило обновление строки
    @ObservedObject var item: CDTodoItem
    
    let action: (Action) -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            
            Button(action: {
                action(.complete(item, !item.completed))
            }) {
                Image(systemName: item.completed ? "checkmark.circle" : "circle")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(item.completed ? .yellow : .secondary)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.borderless)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title ?? "")
                    .strikethrough(item.completed, color: .secondary)
                    .foregroundStyle(item.completed ? .secondary : .primary)
                
                if let descriptionText = item.descriptionText,
                   !descriptionText.isEmpty {
                    Text(descriptionText)
                        .foregroundStyle(item.completed ? .secondary : .primary)
                }
                
                if let dateCreated = item.dateCreated {
                    Text(dateCreated, formatter: dateFormatter)
                        .foregroundStyle(.secondary)
                }
            }
            
        }
        .contextMenu {
            Button(
                action: {
                    action(.edit(item))
                }) {
                    Label("Редактировать", systemImage: "square.and.pencil")
                }
            Button(
                action: {
                    action(.share(item))
                }) {
                    Label("Поделиться", systemImage: "square.and.arrow.up")
                }
            Button(
                role: .destructive,
                action: {
                    action(.delete(item))
                }) {
                    Label("Удалить", systemImage: "trash")
                }
            }
    }
}

extension TodoListRow {
    enum Action {
        case edit(CDTodoItem)
        case share(CDTodoItem)
        case delete(CDTodoItem)
        case complete(CDTodoItem, Bool)
    }
}
    
#Preview {
    CoreDataPreview { _ in
        NavigationStack {
            List {
                TodoListRow(item: CDTodoItem.item1, action: { _ in })
            }
        }
    }
}
