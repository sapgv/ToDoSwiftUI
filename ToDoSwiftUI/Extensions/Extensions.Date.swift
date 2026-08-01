//
//  Extensions.Date.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 31.07.2026.
//

import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
