//
//  Educator.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 30/05/2018.
//

import Foundation

@available(macOS 10.11, iOS 9.0, tvOS 9.0, watchOS 2.0, *)
public struct Educator: Equatable, Decodable {

    public var id: EducatorID?

    public var name: PersonNameComponents?

    public var employments: [Employment]

    public init(id: EducatorID?,
                name: PersonNameComponents?,
                employments: [Employment]) {
        self.id = id
        self.name = name
        self.employments = employments
    }

    private enum CodingKeys: String, CodingKey {
        case id          = "Id"
        case displayName = "DisplayName"
        case fullName    = "FullName"
        case employments = "Employments"
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(EducatorID.self, forKey: .id)

        employments = try container
            .decodeIfPresent([Employment].self, forKey: .employments) ?? []

        guard let shortName = try container
            .decodeIfPresent(String.self,
                             forKey: .displayName)?.nilIfEmpty,
            let fullName = try container
                .decodeIfPresent(String.self,
                                 forKey: .fullName)?.nilIfEmpty else {

            name = nil
            return
        }

        name = .personNameComponents(fromFullName: fullName,
                                     shortName: shortName)
    }
}
