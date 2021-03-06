//
//  Identifiers.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Foundation

public protocol TimetableIdentifier: RawRepresentable,
                                     Hashable,
                                     CustomStringConvertible,
                                     CustomDebugStringConvertible,
                                     Codable {}

extension TimetableIdentifier where RawValue: Codable {

    public var description: String {
        return String(describing: rawValue)
    }

    public var debugDescription: String {
        return description
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()

        let rawValue = try container.decode(RawValue.self)

        if let identifier = Self(rawValue: rawValue) {
            self = identifier
        } else {

            let debugDescription = """
            Unexpected raw value \(rawValue) for \(Self.self)
            """

            throw DecodingError
                .dataCorruptedError(in: container,
                                    debugDescription: debugDescription)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

public struct DivisionAlias: TimetableIdentifier {

    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public struct StudyProgramID: TimetableIdentifier {

    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct StudentGroupID: TimetableIdentifier {

    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct EducatorID: TimetableIdentifier {

    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct AddressID: TimetableIdentifier {

    public var rawValue: UUID

    public init(rawValue: UUID) {
        self.rawValue = rawValue
    }
}

public struct ClassroomID: TimetableIdentifier {

    public var rawValue: UUID

    public init(rawValue: UUID) {
        self.rawValue = rawValue
    }
}
