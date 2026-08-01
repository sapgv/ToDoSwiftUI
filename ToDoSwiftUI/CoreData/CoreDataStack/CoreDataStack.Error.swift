//
//  CoreDataStack.Error.swift
//  SapgvPlatform
//
//  Created by Grigory Sapogov on 16.07.2025.
//

import Foundation

extension CoreDataStack {
    enum CoreDataStackError: LocalizedError {
        case failureToSave
        case failureToFetch
        case failureToInit
        
        public var errorDescription: String? {
            switch self {
            case .failureToSave:
                return "Не удалось сохранить данные"
            case .failureToFetch:
                return "Не удалось получить данные"
            case .failureToInit:
                return "Не удалось создать CoreDataStack"
            }
        }
    }
}
