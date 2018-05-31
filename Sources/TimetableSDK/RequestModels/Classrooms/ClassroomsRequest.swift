//
//  ClassroomsRequest.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 31/05/2018.
//

import Foundation

/// Returns a list of classrooms for an address filtered by a given
/// optional criteria.
///
///     /api/v1/addresses/{oid}/classrooms
public struct ClassroomsRequest: TimetableDecodableRequestProtocol {

    public typealias Result = [Classroom]

    /// The address identifier.
    public var addressID: AddressID

    /// Seating type. Uses any seating type if `nil` is specified.
    public var seating: Seating?

    /// The minimal capacity of a room.
    public var capacity: Int?

    /// The list of desired equipment.
    public var equipment: [String]

    /// Creates a request that fetches a list of classrooms for an address
    /// filtered by a given optional criteria.
    ///
    /// - Parameters:
    ///   - addressID: The address identifier.
    ///   - seating: Seating type. Uses any seating type if `nil` is specified.
    ///   - capacity: The minimal capacity of a room.
    ///   - equipment: The list of desired equipment.
    public init(addressID: AddressID,
                seating: Seating? = nil,
                capacity: Int? = nil,
                equipment: [String] = []) {
        self.addressID = addressID
        self.seating = seating
        self.capacity = capacity
        self.equipment = equipment
    }

    public var path: String {
        return "/api/v1/addresses/\(addressID)/classrooms"
    }

    public var query: [URLQueryItem] {

        var query = [URLQueryItem]()

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
