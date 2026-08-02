//
//  Decoder.swift
//  ToDoSwiftUI
//
//  Created by Grigory Sapogov on 01.08.2026.
//

import Foundation

// Вынесен в ручной DecoderProtocolMock
protocol DecoderProtocol: AnyObject {
    func decode<T>(
        _ type: T.Type,
        from data: Data
    ) throws -> T where T : Decodable
}

extension JSONDecoder: DecoderProtocol {}
