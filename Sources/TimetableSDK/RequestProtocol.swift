//
//  RequestProtocol.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Foundation

public protocol TimetableRequest {

    var path: String { get }

    var method: HTTPMethod { get }

    var parameters: [String : Any] { get }

    static var successStatusCode: HTTPStatusCode { get }
}

extension TimetableRequest {
    public static var successStatusCode: HTTPStatusCode { return 200 }
}

public protocol TimetableDecodableRequest: TimetableRequest {

    associatedtype Result

    static func decodeResult(
        from response: HTTPResponseProtocol
    ) throws -> Result
}

private let decoder = JSONDecoder()

extension TimetableDecodableRequest {

    internal static func getError(
        from response: HTTPResponseProtocol
    ) throws -> TimetableError {

        do {
            return try decoder.decode(TimetableError.self, from: response.data)
        } catch {
            let status = response.statusCode
            if status.category != .success {
                return TimetableError(statusCode: status,
                                      statusCodeDescription: status.description,
                                      errors: [])
            } else {
                throw error
            }
        }
    }
}

extension TimetableDecodableRequest where Result: Decodable {

    public static func decodeResult(
        from response: HTTPResponseProtocol
    ) throws -> Result {

        if response.statusCode == successStatusCode {
            return try decoder.decode(Result.self, from: response.data)
        } else {
            throw try getError(from: response)
        }
    }
}

extension TimetableDecodableRequest where Result == Void {

    public static func decodeResult(
        from response: HTTPResponseProtocol
    ) throws -> Void {

        if response.statusCode == successStatusCode { return }

        throw try getError(from: response)
    }
}

extension TimetableDecodableRequest where Result == Data {

    public static func decodeResult(
        from response: HTTPResponseProtocol
    ) throws -> Data {

        if response.statusCode == successStatusCode {
            return response.data
        } else {
            throw try getError(from: response)
        }
    }
}
