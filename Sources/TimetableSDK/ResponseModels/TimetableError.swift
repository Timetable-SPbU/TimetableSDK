//
//  TimetableError.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Hammond
import struct Foundation.URL

public struct TimetableError: ServerErrorProtocol {

    public var statusCode: HTTPStatusCode?

    public var statusCodeDescription: String?

    public var errors: [String]

    public var helpURL: URL?

    public init(statusCode: HTTPStatusCode?,
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

        // Assuming `statusCodeDescription` has the format
        // "400 (BadRequest)"
        statusCode = (statusCodeDescription?.prefix(3))
            .flatMap { Int($0) }
            .map(HTTPStatusCode.init)

        errors =
            try container.decodeIfPresent([String].self, forKey: .errors) ?? []

        helpURL =
            try container.decodeIfPresent(URL.self, forKey: .helpURL)
    }

    public static func defaultError(
        for statusCode: HTTPStatusCode
    ) -> TimetableError {

        return TimetableError(statusCode: statusCode,
                              statusCodeDescription: statusCode.description,
                              errors: [])
    }
}
