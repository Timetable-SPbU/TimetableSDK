//
//  HTTPStatusCode.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Foundation

public struct HTTPStatusCode: RawRepresentable, Hashable {

    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public enum Category {
        case informational
        case success
        case redirection
        case clientError
        case serverError
        case other
    }

    var category: Category {
        switch rawValue {
        case 100 ..< 200: return .informational
        case 200 ..< 300: return .success
        case 300 ..< 400: return .redirection
        case 400 ..< 500: return .clientError
        case 500 ..< 600: return .serverError
        default:          return .other
        }
    }
}

extension HTTPStatusCode: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: UInt16) {
        self.init(rawValue: Int(value))
    }
}

extension HTTPStatusCode: CustomStringConvertible,
                          CustomDebugStringConvertible {

    public var description: String { return String(rawValue) }

    public var debugDescription: String { return description }
}
