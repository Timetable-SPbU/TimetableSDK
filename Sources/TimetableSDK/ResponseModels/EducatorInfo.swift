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
}
