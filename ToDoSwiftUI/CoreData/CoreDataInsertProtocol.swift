//
//  CoreDataInsertProtocol.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 31.07.2026.
//

import Foundation
import CoreData

protocol CoreDataInsertProtocol: NSManagedObject {
    associatedtype Model
    func fill(model: Model)
}
