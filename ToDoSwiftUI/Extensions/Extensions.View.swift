//
//  Extensions.View.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 01.08.2026.
//

import SwiftUI

extension View {
    func alert(error: Binding<LocalizedAlertError?>, buttonTitle: String = String(localized: "Понятно")) -> some View {
        return alert(isPresented: .constant(error.wrappedValue != nil), error: error.wrappedValue) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}
