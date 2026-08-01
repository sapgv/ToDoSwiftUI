//
//  LocalizedAlertError.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 01.08.2026.
//

import Foundation
import SwiftUI

struct LocalizedAlertError: LocalizedError {
    let errorDescription: String?
    let failureReason: String?
    let recoverySuggestion: String?

    init(error: Error) {
        let localizedError = error as? LocalizedError
        self.errorDescription = error.localizedDescription
        self.failureReason = localizedError != nil ? localizedError!.failureReason : ""
        self.recoverySuggestion = localizedError != nil ? localizedError!.recoverySuggestion : nil
    }
}

extension Error {
    var localizedError: LocalizedError? {
        self as? LocalizedError
    }
    var localizedAlertError: LocalizedAlertError {
        LocalizedAlertError(error: self)
    }
}

extension Binding where Value == Error? {
    var localizedError: LocalizedAlertError? {
        wrappedValue?.localizedAlertError
    }
}

extension Binding where Value == Error {
    var localizedError: LocalizedAlertError {
        wrappedValue.localizedAlertError
    }
}
