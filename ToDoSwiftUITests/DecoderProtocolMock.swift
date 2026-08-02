//
//  DecoderProtocolMock.swift
//  ToDoSwiftUITests
//
//  Created by Grigory Sapogov on 01.08.2026.
//

import Foundation

@testable import ToDoSwiftUI

class DecoderProtocolMock: DecoderProtocol {




    //MARK: - decode<T>

    var decodeTTypeTTypeFromDataData_DecodableThrowableError: (any Error)?
    var decodeTTypeTTypeFromDataData_DecodableCallsCount = 0
    var decodeTTypeTTypeFromDataData_DecodableCalled: Bool {
        return decodeTTypeTTypeFromDataData_DecodableCallsCount > 0
    }
    var decodeTTypeTTypeFromDataData_DecodableReceivedArguments: (type: Any, data: Data)?
    var decodeTTypeTTypeFromDataData_DecodableReceivedInvocations: [(type: Any, data: Data)] = []
    var decodeTTypeTTypeFromDataData_DecodableReturnValue: Any?
    var decodeTTypeTTypeFromDataData_DecodableClosure: ((Any, Data) throws -> Any)?

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        decodeTTypeTTypeFromDataData_DecodableCallsCount += 1
        decodeTTypeTTypeFromDataData_DecodableReceivedArguments = (type: type, data: data)
        decodeTTypeTTypeFromDataData_DecodableReceivedInvocations.append((type: type, data: data))
        if let error = decodeTTypeTTypeFromDataData_DecodableThrowableError {
            throw error
        }
        if let decodeTTypeTTypeFromDataData_DecodableClosure = decodeTTypeTTypeFromDataData_DecodableClosure {
            return try decodeTTypeTTypeFromDataData_DecodableClosure(type, data) as! T
        } else {
            return decodeTTypeTTypeFromDataData_DecodableReturnValue as! T
        }
    }


}
