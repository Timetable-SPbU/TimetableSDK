//
//  HTTPMethod.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

public struct HTTPMethod: RawRepresentable, Hashable {

    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    static let get = HTTPMethod(rawValue: "GET")
}
