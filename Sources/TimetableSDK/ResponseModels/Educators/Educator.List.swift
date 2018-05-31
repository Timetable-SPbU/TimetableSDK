//
//  Educator.List.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 30/05/2018.
//

import Foundation

@available(macOS 10.11, iOS 9.0, tvOS 9.0, watchOS 2.0, *)
extension Educator {

    public struct List: Equatable, Decodable {

        public var lastNameQuery: String?

        public var educators: [Educator]

        public init(lastNameQuery: String?, educators: [Educator]) {
            self.lastNameQuery = lastNameQuery
            self.educators = educators
        }

        private enum CodingKeys: String, CodingKey {
            case lastNameQuery = "EducatorLastNameQuery"
            case educators     = "Educators"
        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            lastNameQuery = try container
                .decodeIfPresent(String.self, forKey: .lastNameQuery)

            educators = try container
                .decodeIfPresent([Educator].self, forKey: .educators) ?? []
        }
    }
}
