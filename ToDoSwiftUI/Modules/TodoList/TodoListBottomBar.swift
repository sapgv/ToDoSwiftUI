//
//  TodoListBottomBar.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import SwiftUI

struct TodoListBottomBar: View {
    let itemCount: Int
    let action: () -> Void
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                Spacer()
                    .frame(maxWidth: .infinity)
                
                Text(LocalizedStringKey("\(itemCount) task_count_key"))
                    .foregroundStyle(.secondary)
                
                Button {
                    action()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
                .tint(.yellow)
                .frame(maxWidth: .infinity, alignment: .trailing)

            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
        .background(.bar)
    }
}

#Preview {
    TodoListBottomBar(itemCount: 3, action: {}) 
}
