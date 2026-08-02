//
//  Session.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 01.08.2026.
//

import Foundation

// sourcery: AutoMockable
protocol NetworkClientProtocol: AnyObject {
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse)
}

extension NetworkClientProtocol {
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)? = nil
    ) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: delegate)
    }
}

extension URLSession: NetworkClientProtocol {}
