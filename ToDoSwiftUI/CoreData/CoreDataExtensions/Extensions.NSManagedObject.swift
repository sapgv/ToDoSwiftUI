//
//  Extensions.NSManagedObject.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 31.07.2026.
//

import CoreData

extension NSManagedObject {
    static var entityName: String {
        return String(describing: self)
    }
}
