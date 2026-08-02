//
//  ToDoSwiftUITests.swift
//  ToDoSwiftUITests
//
//  Created by Grigory Sapogov on 01.08.2026.
//

import Quick
import Nimble

@testable import ToDoSwiftUI

@MainActor
final class TodoFetchServiceTests: AsyncSpec {

    override class func spec() {
        var sut: TodoFetchService!
        var decoder: DecoderProtocolMock!
        var networkClient: NetworkClientProtocolMock!
        
        beforeEach {
            decoder = .init()
            networkClient = .init()
            
            sut = await .init(decoder: decoder, networkClient: networkClient)
        }
        
        describe(".fetch") {
            context("when session fails") {
                beforeEach {
                    networkClient.dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseThrowableError = TodoFetchService.Errors.fetchFailure
                }
                it("should throw error") {
                    await expect {
                        try await sut.fetch()
                    }
                    .to(throwError(TodoFetchService.Errors.fetchFailure))
                    expect(networkClient.dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseCallsCount).to(equal(1))
                    expect(networkClient.dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReceivedArguments?.request).to(equal(TestData.request))
                }
            }
            context("when decoder fails") {
                beforeEach {
                    networkClient.dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReturnValue = (TestData.responseData, .init())
                    decoder.decodeTTypeTTypeFromDataData_DecodableThrowableError = TestData.error
                }
                it("should throw error") {
                    await expect {
                        try await sut.fetch()
                    }
                    .to(throwError(TodoFetchService.Errors.fetchFailure))
                    expect(networkClient.dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseCallsCount).to(equal(1))
                    expect(networkClient.dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReceivedArguments?.request).to(equal(TestData.request))
                    expect(decoder.decodeTTypeTTypeFromDataData_DecodableCallsCount).to(equal(1))
                    expect(decoder.decodeTTypeTTypeFromDataData_DecodableReceivedArguments?.data).to(equal(TestData.responseData))
                }
            }
            context("when decoder success") {
                beforeEach {
                    networkClient.dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReturnValue = (TestData.responseData, .init())
                    decoder.decodeTTypeTTypeFromDataData_DecodableReturnValue = TestData.result
                }
                it("should throw error") {
                    var result: [TodoItem] = []
                    await expect {
                        result = try await sut.fetch()
                    }
                    .toNot(throwError())
                    expect(networkClient.dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseCallsCount).to(equal(1))
                    expect(networkClient.dataForRequestURLRequestDelegateAnyURLSessionTaskDelegate_DataURLResponseReceivedArguments?.request).to(equal(TestData.request))
                    expect(decoder.decodeTTypeTTypeFromDataData_DecodableCallsCount).to(equal(1))
                    expect(decoder.decodeTTypeTTypeFromDataData_DecodableReceivedArguments?.data).to(equal(TestData.responseData))
                    expect(result).to(equal(TestData.items))
                }
            }
        }
    }
}
    
// MARK: - Private

private extension TodoFetchServiceTests {
    enum TestData {
        static let error = TodoFetchService.Errors.fetchFailure
        static let request: URLRequest = .init(url: URL(string: "https://dummyjson.com/todos")!)
        static let responseDictionary: [String: Any] = [
            "todos": [
                [
                    "id": 1,
                    "todo": "Do something nice for someone you care about",
                    "completed": false,
                    "userId": 152
                ]
            ]
        ]
        static let responseData = Data()
        static let items: [TodoItem] = [
            .init(
                uuid: UUID(),
                dateCreated: Date(),
                title: "title",
                descriptionText: "descriptionText",
                completed: false
            )
        ]
        static let result = TodoFetchService.FetchResult(todos: items)
    }
}
