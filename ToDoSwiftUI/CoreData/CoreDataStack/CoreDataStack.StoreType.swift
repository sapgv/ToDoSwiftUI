//
//  CoreDataStack.StoreType.swift
//  SapgvPlatform
//
//  Created by Grigory Sapogov on 16.07.2025.
//

import Foundation

extension CoreDataStack {
    public enum StoreType: String {
        case sql = "SQLite"
        case inMemory = "InMemory"
    }

}
