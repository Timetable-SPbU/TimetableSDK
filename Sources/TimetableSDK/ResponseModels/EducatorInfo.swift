//
//  EducatorInfo.swift
//  Hammond
//
//  Created by Sergej Jaskiewicz on 15/04/2018.
//

public struct EducatorInfo: Equatable, Decodable {

    public var identifier: EducatorID?

    public var name: String?

    public init(identifier: EducatorID?, name: String?) {
        self.identifier = identifier
        self.name = name
    }

    private enum CodingKeys: String, CodingKey {
        case identifier = "Item1"
        case name       = "Item2"
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        identifier = try container
            .decodeIfPresent(EducatorID.self, forKey: .identifier)

        name = try container
            .decodeIfPresent(String.self, forKey: .name)?.nilIfEmpty
    }
}
