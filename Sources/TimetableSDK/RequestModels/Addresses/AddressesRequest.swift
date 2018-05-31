//
//  AddressesRequest.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 31/05/2018.
//

import Foundation

/// Returns a list of addresses filtered by a given optional criteria.
///
///     GET /api/v1/addresses
public struct AddressesRequest: TimetableDecodableRequestProtocol {

    public typealias Result = [Address]

    /// Seating type. Uses any seating type if `nil` is specified.
    public var seating: Seating?

    /// The minimal capacity of a room.
    public var capacity: Int?

    /// The list of desired equipment.
    public var equipment: [String]

    /// Creates a request that fetches addresses filtered by a given
    /// optional criteria.
    ///
    /// - Parameters:
    ///   - seating: Seating type. Uses any seating type if `nil` is specified.
    ///   - capacity: The minimal capacity of a room.
    ///   - equipment: The list of desired equipment.
    public init(seating: Seating? = nil,
                capacity: Int? = nil,
                equipment: [String] = []) {
        self.seating = seating
        self.capacity = capacity
        self.equipment = equipment
    }

    public var path: String {
        return "/api/v1/addresses"
    }

    public var query: [URLQueryItem] {

        var query = [URLQueryItem]()
        query.reserveCapacity(3)

        seating.map {
            query.append(.init(name: "seating", value: "\($0.rawValue)"))
        }

        capacity.map {
            query.append(.init(name: "capacity", value: "\($0)"))
        }

        if !equipment.isEmpty {
            query.append(.init(name: "equipment",
                              value: equipment.joined(separator: ",")))
        }

        return query
    }
}
