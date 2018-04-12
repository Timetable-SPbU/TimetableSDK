//
//  TimetableError.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Foundation

public struct TimetableError: Error, Decodable {

    public var statusCode: HTTPStatusCode?

    public var statusCodeDescription: String?

    public var errors: [String]

    public var helpURL: URL?

    internal init(statusCode: HTTPStatusCode?,
                  statusCodeDescription: String?,
                  errors: [String],
                  helpURL: URL? = nil) {
        self.statusCode = statusCode
        self.statusCodeDescription = statusCodeDescription
        self.errors = errors
        self.helpURL = helpURL
    }

    private enum CodingKeys: String, CodingKey {
        case statusCodeDescription = "statusCode"
        case errors
        case helpURL               = "helpUrl"
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        statusCodeDescription =
            try container.decodeIfPresent(String.self,
                                          forKey: .statusCodeDescription)
        errors =
            try container.decodeIfPresent([String].self, forKey: .errors) ?? []

        helpURL
            = try container.decodeIfPresent(URL.self, forKey: .helpURL)
    }
}
