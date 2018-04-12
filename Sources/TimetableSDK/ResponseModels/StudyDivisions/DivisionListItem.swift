//
//  DivisionListItem.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Foundation

public struct DivisionListItem: Decodable, Equatable {

    public var oid: UUID?

    /// Short name code.
    public var alias: DivisionAlias?

    /// The name of the division.
    public var name: String?

    public init(oid: UUID? = nil, alias: DivisionAlias?, name: String) {
        self.oid = oid
        self.alias = alias
        self.name = name
    }

    private enum CodingKeys: String, CodingKey {
        case oid   = "Oid"
        case alias = "Alias"
        case name  = "Name"
    }
}
