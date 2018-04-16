//
//  TimetableRequestProtocol.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Hammond
import Foundation

public protocol TimetableRequestProtocol: RequestProtocol {

    var method: HTTPMethod { get }

    var query: [URLQueryItem] { get }
}

extension TimetableRequestProtocol {

    public var method: HTTPMethod { return .get }

    public var query: [URLQueryItem] { return [] }
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
