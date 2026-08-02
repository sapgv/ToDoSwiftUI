// Generated using Sourcery 2.3.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import CoreData

@testable import ToDoSwiftUI
























class DecoderProtocolMock: DecoderProtocol {




    //MARK: - decode<T>

    var decodeTTypeTTypeFromDataData_DecodableThrowableError: (any Error)?
    var decodeTTypeTTypeFromDataData_DecodableCallsCount = 0
    var decodeTTypeTTypeFromDataData_DecodableCalled: Bool {
        return decodeTTypeTTypeFromDataData_DecodableCallsCount > 0
    }
    var decodeTTypeTTypeFromDataData_DecodableReceivedArguments: (type: T.Type, data: Data)?
    var decodeTTypeTTypeFromDataData_DecodableReceivedInvocations: [(type: T.Type, data: Data)] = []
    var decodeTTypeTTypeFromDataData_DecodableReturnValue: T where T : Decodable!
    var decodeTTypeTTypeFromDataData_DecodableClosure: ((T.Type, Data) throws -> T where T : Decodable)?

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        decodeTTypeTTypeFromDataData_DecodableCallsCount += 1
        decodeTTypeTTypeFromDataData_DecodableReceivedArguments = (type: type, data: data)
        decodeTTypeTTypeFromDataData_DecodableReceivedInvocations.append((type: type, data: data))
        if let error = decodeTTypeTTypeFromDataData_DecodableThrowableError {
            throw error
        }
        if let decodeTTypeTTypeFromDataData_DecodableClosure = decodeTTypeTTypeFromDataData_DecodableClosure {
            return try decodeTTypeTTypeFromDataData_DecodableClosure(type, data)
        } else {
            return decodeTTypeTTypeFromDataData_DecodableReturnValue
        }
    }


}
class NetworkClientProtocolMock: NetworkClientProtocol {




    //MARK: - data

    var dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseThrowableError: (any Error)?
    var dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseCallsCount = 0
    var dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseCalled: Bool {
        return dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseCallsCount > 0
    }
    var dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReceivedArguments: (request: URLRequest, delegate: (any URLSessionTaskDelegate)?)?
    var dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReceivedInvocations: [(request: URLRequest, delegate: (any URLSessionTaskDelegate)?)] = []
    var dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReturnValue: (Data, URLResponse)!
    var dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseClosure: ((URLRequest, (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse))?

    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseCallsCount += 1
        dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReceivedArguments = (request: request, delegate: delegate)
        dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReceivedInvocations.append((request: request, delegate: delegate))
        if let error = dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseThrowableError {
            throw error
        }
        if let dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseClosure = dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseClosure {
            return try await dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseClosure(request, delegate)
        } else {
            return dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReturnValue
        }
    }


}
class TodoFetchServiceProtocolMock: TodoFetchServiceProtocol {




    //MARK: - fetch

    var fetchTodoItemThrowableError: (any Error)?
    var fetchTodoItemCallsCount = 0
    var fetchTodoItemCalled: Bool {
        return fetchTodoItemCallsCount > 0
    }
    var fetchTodoItemReturnValue: [TodoItem]!
    var fetchTodoItemClosure: (() async throws -> [TodoItem])?

    func fetch() async throws -> [TodoItem] {
        fetchTodoItemCallsCount += 1
        if let error = fetchTodoItemThrowableError {
            throw error
        }
        if let fetchTodoItemClosure = fetchTodoItemClosure {
            return try await fetchTodoItemClosure()
        } else {
            return fetchTodoItemReturnValue
        }
    }


}
class TodoStorageProtocolMock: TodoStorageProtocol {




    //MARK: - fetchCount

    var fetchCountIntThrowableError: (any Error)?
    var fetchCountIntCallsCount = 0
    var fetchCountIntCalled: Bool {
        return fetchCountIntCallsCount > 0
    }
    var fetchCountIntReturnValue: Int!
    var fetchCountIntClosure: (() async throws -> Int)?

    func fetchCount() async throws -> Int {
        fetchCountIntCallsCount += 1
        if let error = fetchCountIntThrowableError {
            throw error
        }
        if let fetchCountIntClosure = fetchCountIntClosure {
            return try await fetchCountIntClosure()
        } else {
            return fetchCountIntReturnValue
        }
    }

    //MARK: - insertItems

    var insertItemsItemsTodoItemVoidThrowableError: (any Error)?
    var insertItemsItemsTodoItemVoidCallsCount = 0
    var insertItemsItemsTodoItemVoidCalled: Bool {
        return insertItemsItemsTodoItemVoidCallsCount > 0
    }
    var insertItemsItemsTodoItemVoidReceivedItems: ([TodoItem])?
    var insertItemsItemsTodoItemVoidReceivedInvocations: [([TodoItem])] = []
    var insertItemsItemsTodoItemVoidClosure: (([TodoItem]) async throws -> Void)?

    func insertItems(items: [TodoItem]) async throws {
        insertItemsItemsTodoItemVoidCallsCount += 1
        insertItemsItemsTodoItemVoidReceivedItems = items
        insertItemsItemsTodoItemVoidReceivedInvocations.append(items)
        if let error = insertItemsItemsTodoItemVoidThrowableError {
            throw error
        }
        try await insertItemsItemsTodoItemVoidClosure?(items)
    }

    //MARK: - saveItem

    var saveItemItemTodoItemVoidThrowableError: (any Error)?
    var saveItemItemTodoItemVoidCallsCount = 0
    var saveItemItemTodoItemVoidCalled: Bool {
        return saveItemItemTodoItemVoidCallsCount > 0
    }
    var saveItemItemTodoItemVoidReceivedItem: (TodoItem)?
    var saveItemItemTodoItemVoidReceivedInvocations: [(TodoItem)] = []
    var saveItemItemTodoItemVoidClosure: ((TodoItem) async throws -> Void)?

    func saveItem(_ item: TodoItem) async throws {
        saveItemItemTodoItemVoidCallsCount += 1
        saveItemItemTodoItemVoidReceivedItem = item
        saveItemItemTodoItemVoidReceivedInvocations.append(item)
        if let error = saveItemItemTodoItemVoidThrowableError {
            throw error
        }
        try await saveItemItemTodoItemVoidClosure?(item)
    }

    //MARK: - deleteItem

    var deleteItemCdItemIdNSManagedObjectIDVoidThrowableError: (any Error)?
    var deleteItemCdItemIdNSManagedObjectIDVoidCallsCount = 0
    var deleteItemCdItemIdNSManagedObjectIDVoidCalled: Bool {
        return deleteItemCdItemIdNSManagedObjectIDVoidCallsCount > 0
    }
    var deleteItemCdItemIdNSManagedObjectIDVoidReceivedCdItemId: (NSManagedObjectID)?
    var deleteItemCdItemIdNSManagedObjectIDVoidReceivedInvocations: [(NSManagedObjectID)] = []
    var deleteItemCdItemIdNSManagedObjectIDVoidClosure: ((NSManagedObjectID) async throws -> Void)?

    func deleteItem(_ cdItemId: NSManagedObjectID) async throws {
        deleteItemCdItemIdNSManagedObjectIDVoidCallsCount += 1
        deleteItemCdItemIdNSManagedObjectIDVoidReceivedCdItemId = cdItemId
        deleteItemCdItemIdNSManagedObjectIDVoidReceivedInvocations.append(cdItemId)
        if let error = deleteItemCdItemIdNSManagedObjectIDVoidThrowableError {
            throw error
        }
        try await deleteItemCdItemIdNSManagedObjectIDVoidClosure?(cdItemId)
    }

    //MARK: - complete

    var completeCdItemIdNSManagedObjectIDValueBoolVoidThrowableError: (any Error)?
    var completeCdItemIdNSManagedObjectIDValueBoolVoidCallsCount = 0
    var completeCdItemIdNSManagedObjectIDValueBoolVoidCalled: Bool {
        return completeCdItemIdNSManagedObjectIDValueBoolVoidCallsCount > 0
    }
    var completeCdItemIdNSManagedObjectIDValueBoolVoidReceivedArguments: (cdItemId: NSManagedObjectID, value: Bool)?
    var completeCdItemIdNSManagedObjectIDValueBoolVoidReceivedInvocations: [(cdItemId: NSManagedObjectID, value: Bool)] = []
    var completeCdItemIdNSManagedObjectIDValueBoolVoidClosure: ((NSManagedObjectID, Bool) async throws -> Void)?

    func complete(_ cdItemId: NSManagedObjectID, value: Bool) async throws {
        completeCdItemIdNSManagedObjectIDValueBoolVoidCallsCount += 1
        completeCdItemIdNSManagedObjectIDValueBoolVoidReceivedArguments = (cdItemId: cdItemId, value: value)
        completeCdItemIdNSManagedObjectIDValueBoolVoidReceivedInvocations.append((cdItemId: cdItemId, value: value))
        if let error = completeCdItemIdNSManagedObjectIDValueBoolVoidThrowableError {
            throw error
        }
        try await completeCdItemIdNSManagedObjectIDValueBoolVoidClosure?(cdItemId, value)
    }


}
