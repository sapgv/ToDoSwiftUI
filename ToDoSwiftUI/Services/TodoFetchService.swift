//
//  TodoFetchService.swift
//  TodoViper
//
//  Created by Grigory Sapogov on 23.07.2026.
//

import Foundation

protocol TodoFetchServiceProtocol: AnyObject {
    func fetch() async throws -> [TodoItem]
}

final class TodoFetchService {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
}

extension TodoFetchService: TodoFetchServiceProtocol {
    func fetch() async throws -> [TodoItem] {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            throw Errors.fetchFailure
        }
        do {
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            let result = try decoder.decode(FetchResult.self, from: data)
            return result.todos
        }
        catch {
            throw Errors.fetchFailure
        }
    }
}

// MARK: - Private

private extension TodoFetchService {
    struct FetchResult: Decodable {
        let todos: [TodoItem]
    }
}

// MARK: - Errors

private extension TodoFetchService {
    enum Errors: LocalizedError {
        case fetchFailure
        var errorDescription: String? {
            switch self {
            case .fetchFailure:
                "Не удалось получить данные"
            }
        }
    }
}
