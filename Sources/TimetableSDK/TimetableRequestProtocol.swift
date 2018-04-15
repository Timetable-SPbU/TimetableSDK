//
//  TimetableRequestProtocol.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Hammond
import struct Foundation.Data

public protocol TimetableRequestProtocol: RequestProtocol {
    var method: HTTPMethod { get }
}

extension TimetableRequestProtocol {
    public var method: HTTPMethod { return .get }
}

public protocol TimetableDecodableRequestProtocol: TimetableRequestProtocol,
                                                   DecodableRequestProtocol {
    associatedtype ServerError = TimetableError
}

extension TimetableDecodableRequestProtocol {

    public static func deserializeResult<T: Decodable>(
        from data: Data
    ) throws -> T {
        return try Decoding.decoder.decode(T.self, from: data)
    }
}
