//
//  ToDoSwiftUITests.swift
//  ToDoSwiftUITests
//
//  Created by Grigory Sapogov on 01.08.2026.
//

import Quick
import Nimble
import CoreData

@testable import ToDoSwiftUI

@MainActor
final class TodoModelTests: AsyncSpec {

    override class func spec() {
        var sut: TodoModel!
        var fetchService: TodoFetchServiceProtocolMock!
        var storage: TodoStorageProtocolMock!
        
        beforeEach {
            fetchService = .init()
            storage = .init()
            sut = await .init(fetchService: fetchService, storage: storage)
        }
        
        describe(".loadItems") {
            context("when storage fetchCount is not 0") {
                beforeEach {
                    storage.fetchCountIntReturnValue = 1
                }
                it("should not call fetchService") {
                    await expect {
                        try await sut.loadItems()
                    }.toNot(throwError())
                    expect(fetchService.fetchTodoItemCallsCount).to(equal(0))
                }
            }
            context("when storage fetchCount is 0") {
                context("when fetchService failure") {
                    beforeEach {
                        storage.fetchCountIntReturnValue = 0
                        fetchService.fetchTodoItemThrowableError = TodoFetchService.Errors.fetchFailure
                    }
                    it("should call fetchService") {
                        await expect {
                            try await sut.loadItems()
                        }.to(throwError(TodoFetchService.Errors.fetchFailure))
                        expect(fetchService.fetchTodoItemCallsCount).to(equal(1))
                    }
                }
                context("when fetchService success") {
                    beforeEach {
                        storage.fetchCountIntReturnValue = 0
                        fetchService.fetchTodoItemReturnValue = TestData.items
                    }
                    it("should call fetchService") {
                        await expect {
                            try await sut.loadItems()
                        }.toNot(throwError())
                        expect(fetchService.fetchTodoItemCallsCount).to(equal(1))
                        expect(fetchService.fetchTodoItemReturnValue).to(equal(TestData.items))
                    }
                }
                context("when storage insert failure") {
                    beforeEach {
                        storage.fetchCountIntReturnValue = 0
                        fetchService.fetchTodoItemReturnValue = TestData.items
                        storage.insertItemsItemsTodoItemVoidThrowableError = CoreDataStack.CoreDataStackError.failureToSave
                    }
                    it("should throw error") {
                        await expect {
                            try await sut.loadItems()
                        }.to(throwError(CoreDataStack.CoreDataStackError.failureToSave))
                        expect(fetchService.fetchTodoItemCallsCount).to(equal(1))
                        expect(fetchService.fetchTodoItemReturnValue).to(equal(TestData.items))
                        expect(storage.insertItemsItemsTodoItemVoidCallsCount).to(equal(1))
                    }
                }
                context("when storage insert success") {
                    beforeEach {
                        storage.fetchCountIntReturnValue = 0
                        fetchService.fetchTodoItemReturnValue = TestData.items
                    }
                    it("should call insertItems") {
                        await expect {
                            try await sut.loadItems()
                        }.toNot(throwError())
                        expect(fetchService.fetchTodoItemCallsCount).to(equal(1))
                        expect(fetchService.fetchTodoItemReturnValue).to(equal(TestData.items))
                        expect(storage.insertItemsItemsTodoItemVoidCallsCount).to(equal(1))
                    }
                }
            }
        }
        
        describe(".insertItems") {
            context("when storage.insertItems failure") {
                beforeEach {
                    storage.insertItemsItemsTodoItemVoidThrowableError = CoreDataStack.CoreDataStackError.failureToSave
                }
                it("should throw error") {
                    await expect {
                        try await sut.insertItems(TestData.items)
                    }.to(throwError(CoreDataStack.CoreDataStackError.failureToSave))
                    expect(storage.insertItemsItemsTodoItemVoidCallsCount).to(equal(1))
                    expect(storage.insertItemsItemsTodoItemVoidReceivedItems).to(equal(TestData.items))
                }
            }
            context("when storage.insertItems success") {
                it("should not throw error") {
                    await expect {
                        try await sut.insertItems(TestData.items)
                    }.toNot(throwError())
                    expect(storage.insertItemsItemsTodoItemVoidCallsCount).to(equal(1))
                    expect(storage.insertItemsItemsTodoItemVoidReceivedItems).to(equal(TestData.items))
                }
            }
        }
        
        describe(".saveItem") {
            context("when storage.saveItem failure") {
                beforeEach {
                    storage.saveItemItemTodoItemVoidThrowableError = CoreDataStack.CoreDataStackError.failureToSave
                }
                it("should throw error") {
                    await expect {
                        try await sut.saveItem(TestData.item)
                    }.to(throwError(CoreDataStack.CoreDataStackError.failureToSave))
                    expect(storage.saveItemItemTodoItemVoidCallsCount).to(equal(1))
                    expect(storage.saveItemItemTodoItemVoidReceivedItem).to(equal(TestData.item))
                }
            }
            context("when storage.saveItem success") {
                it("should not throw error") {
                    await expect {
                        try await sut.saveItem(TestData.item)
                    }.toNot(throwError())
                    expect(storage.saveItemItemTodoItemVoidCallsCount).to(equal(1))
                    expect(storage.saveItemItemTodoItemVoidReceivedItem).to(equal(TestData.item))
                }
            }
        }
        
        describe(".deleteItem") {
            context("when storage.deleteItem failure") {
                beforeEach {
                    storage.deleteItemCdItemIdNSManagedObjectIDVoidThrowableError = CoreDataStack.CoreDataStackError.failureToSave
                }
                it("should throw error") {
                    await expect {
                        try await sut.deleteItem(TestData.cdItem)
                    }.to(throwError(CoreDataStack.CoreDataStackError.failureToSave))
                    expect(storage.deleteItemCdItemIdNSManagedObjectIDVoidCallsCount).to(equal(1))
                    expect(storage.deleteItemCdItemIdNSManagedObjectIDVoidReceivedCdItemId).to(equal(TestData.cdItemId))
                }
            }
            context("when storage.deleteItem success") {
                it("should not throw error") {
                    await expect {
                        try await sut.deleteItem(TestData.cdItem)
                    }.toNot(throwError())
                    expect(storage.deleteItemCdItemIdNSManagedObjectIDVoidCallsCount).to(equal(1))
                    expect(storage.deleteItemCdItemIdNSManagedObjectIDVoidReceivedCdItemId).to(equal(TestData.cdItemId))
                }
            }
        }
        
        describe(".update") {
            context("when storage.complete failure") {
                beforeEach {
                    storage.completeCdItemIdNSManagedObjectIDValueBoolVoidThrowableError = CoreDataStack.CoreDataStackError.failureToSave
                }
                it("should throw error") {
                    await expect {
                        try await sut.update(TestData.cdItem, value: true)
                    }.to(throwError(CoreDataStack.CoreDataStackError.failureToSave))
                    expect(storage.completeCdItemIdNSManagedObjectIDValueBoolVoidCallsCount).to(equal(1))
                    expect(storage.completeCdItemIdNSManagedObjectIDValueBoolVoidReceivedArguments?.cdItemId).to(equal(TestData.cdItemId))
                }
            }
            context("when storage.complete success") {
                it("should not throw error") {
                    await expect {
                        try await sut.update(TestData.cdItem, value: true)
                    }.toNot(throwError())
                    expect(storage.completeCdItemIdNSManagedObjectIDValueBoolVoidCallsCount).to(equal(1))
                    expect(storage.completeCdItemIdNSManagedObjectIDValueBoolVoidReceivedArguments?.cdItemId).to(equal(TestData.cdItemId))
                }
            }
        }
    }
}
    
// MARK: - Private

private extension TodoModelTests {
    enum TestData {
        static let item = TodoItem(
            uuid: UUID(),
            dateCreated: Date(),
            title: "title",
            descriptionText: "descriptionText",
            completed: false
        )
        static var items: [TodoItem] = [item]
        static let coreDataStack: CoreDataStack = CoreDataStack.sample()
        static let cdItem = CDTodoItem(context: coreDataStack.context)
        static let cdItemId = cdItem.objectID
    }
}
