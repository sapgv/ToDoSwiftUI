//
//  TodoFetchService.swift
//  TodoViper
//
//  Created by Grigory Sapogov on 23.07.2026.
//

import Foundation

// sourcery: AutoMockable
protocol TodoFetchServiceProtocol: AnyObject {
    func fetch() async throws -> [TodoItem]
}

final class TodoFetchService {
    private let decoder: DecoderProtocol
    private let networkClient: NetworkClientProtocol
    
    init(
        decoder: DecoderProtocol = JSONDecoder(),
        networkClient: NetworkClientProtocol = URLSession.shared
    ) {
        self.decoder = decoder
        self.networkClient = networkClient
    }
}

extension TodoFetchService: TodoFetchServiceProtocol {
    func fetch() async throws -> [TodoItem] {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            throw Errors.fetchFailure
        }
        do {
            let request = URLRequest(url: url)
            let (data, _) = try await networkClient.data(for: request)
            let result = try decoder.decode(FetchResult.self, from: data)
            return result.todos
        }
        catch {
            throw Errors.fetchFailure
        }
    }
}

// MARK: - Errors

extension TodoFetchService {
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

// MARK: - FetchResult

extension TodoFetchService {
    struct FetchResult: Decodable {
        let todos: [TodoItem]
    }
}
