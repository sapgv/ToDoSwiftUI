//
//  TodoDetailView.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import SwiftUI

struct TodoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dateFormatter) private var dateFormatter: DateFormatter
    @Environment(TodoModel.self) private var model
    
    @State var item: TodoItem
    let isNew: Bool
    @State private var showSelecteDate = false
    @State private var error: LocalizedAlertError?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                TextField("Заголовок", text: $item.title, axis: .vertical)
                    .font(.system(size: 34, weight: .bold))
                
                Text(item.dateCreated, formatter: dateFormatter)
                    .foregroundStyle(.secondary)
                    .onTapGesture { showSelecteDate = true }
                
                TextField("Описание", text: $item.descriptionText, axis: .vertical)

            }
            .padding()
        }
        .onChange(of: $item.dateCreated, { showSelecteDate = false })
        .sheet(isPresented: $showSelecteDate) {
            DatePicker("Дата", selection: $item.dateCreated, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .presentationDetents([.medium])
        }
        .toolbar {
//            ToolbarTitleMenu()
            ToolbarItem {
                Button("Сохранить", action: save)
                    .disabled(item.title.isEmpty)
            }
        }
//        .navigationBackButtonTitle("Назад")
//        .na
//        .toolbarTitleMenu(content: {
//            Button("Сохранить 2", action: save)
//        })
        .alert(error: $error)
    }
}

extension TodoDetailView {
    struct EditItem: Hashable {
        let isNew: Bool
        let item: TodoItem
    }
}

// MARK: - Private

private extension TodoDetailView {
    func save() {
        Task {
            do {
                if isNew {
                    try await model.insertItems([item])
                }
                else {
                    try await model.saveItem(item)
                }
                dismiss()
            }
            catch {
                self.error = error.localizedAlertError
            }
        }
    }
}

#Preview {
    CoreDataPreview { _ in
        NavigationStack {
            TodoDetailView(item: .init(cdTodoItem: CDTodoItem.item1), isNew: false)
        }
    }
}
