//
//  Address.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 31/05/2018.
//

import Foundation

public struct Address: Equatable, Decodable {

    /// This address's identifier.
    public var id: AddressID?

    // The description of the address.
    public var name: String?

    /// Number of the address classrooms that matched the request criteria.
    public var matches: Int?

    /// Creates a new address.
    ///
    /// - Parameters:
    ///   - id: This address's identifier.
    ///   - name: The description of the address.
    ///   - matches: Number of the address classrooms that matched
    ///              the request criteria.
    public init(id: AddressID?, name: String?, matches: Int?) {
        self.id = id
        self.name = name
        self.matches = matches
    }

    private enum CodingKeys: String, CodingKey {
        case id      = "Oid"
        case name    = "DisplayName1"
        case matches = "matches"
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container
            .decodeIfPresent(String.self, forKey: .id)?
            .nilIfEmpty
            .flatMap(UUID.init)
            .map(AddressID.init)

        name = try container
            .decodeIfPresent(String.self, forKey: .name)?.nilIfEmpty

        matches = try container.decodeIfPresent(Int.self, forKey: .matches)
    }
}
