//
//  Extensions.DateFormatter.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 28.07.2026.
//

import Foundation
import SwiftUI

extension DateFormatter {
    static let `default`: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
}

struct DateFormatterKey: EnvironmentKey {
    static let defaultValue: DateFormatter = DateFormatter.default
}

extension EnvironmentValues {
    var dateFormatter: DateFormatter {
        get { self[DateFormatterKey.self] }
        set { self[DateFormatterKey.self] = newValue }
    }
}
