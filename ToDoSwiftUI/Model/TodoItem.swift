//
//  TodoItem.swift
//  TodoViper
//
//  Created by Grigory Sapogov on 23.07.2026.
//

import Foundation

struct TodoItem: Decodable, Hashable {
    let uuid: UUID?
    var dateCreated: Date
    var title: String
    var descriptionText: String
    var completed: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case todo
        case completed
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = UUID()
        self.dateCreated = Date().startOfDay
        self.title = try container.decode(String.self, forKey: .todo)
        self.descriptionText = ""
        self.completed = try container.decode(Bool.self, forKey: .completed)
    }
    
    init(cdTodoItem: CDTodoItem) {
        self.uuid = cdTodoItem.uuid
        self.dateCreated = cdTodoItem.dateCreated ?? Date().startOfDay
        self.title = cdTodoItem.title ?? ""
        self.descriptionText = cdTodoItem.descriptionText ?? ""
        self.completed = cdTodoItem.completed
    }
    
    init(
        uuid: UUID? = UUID(),
        dateCreated: Date = Date().startOfDay,
        title: String = "",
        descriptionText: String = "",
        completed: Bool = false
    ) {
        self.uuid = uuid
        self.dateCreated = dateCreated
        self.title = title
        self.descriptionText = descriptionText
        self.completed = completed
    }
}
