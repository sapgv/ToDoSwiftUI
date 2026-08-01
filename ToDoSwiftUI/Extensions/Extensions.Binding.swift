//
//  Extensions.Binding.swift
//  SimpleOrders
//
//  Created by Grigory Sapogov on 03.01.2026.
//

import SwiftUI

extension Binding {
    func defaultValue<T: Sendable>(_ defaultValue: T) -> Binding<T> where Value == T? {
      guard let value = wrappedValue else {
          return Binding<T>(
            get: { defaultValue },
            set: { self.wrappedValue = $0 }
         )
      }
      return Binding<T>(
         get: { value },
         set: { self.wrappedValue = $0 }
      )
   }
}

extension Binding: @retroactive Equatable where Value: Equatable {
    public static func == (left: Binding<Value>, right: Binding<Value>) -> Bool {
        left.wrappedValue == right.wrappedValue
    }
}
