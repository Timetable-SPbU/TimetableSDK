//
//  Classroom.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 31/05/2018.
//

import Foundation

public struct Classroom: Equatable, Decodable {

    /// The classroom's identifier.
    public var id: ClassroomID?

    /// The classroom's name.
    public var name: String?

    /// The type of seating in the classroom.
    public var seating: Seating?

    /// The capacity of the room (number of seatings).
    public var capacity: Int?

    /// The additional information.
    public var additionalInfo: String?


    /// Creates a new classroom.
    ///
    /// - Parameters:
    ///   - id: The classroom's identifier.
    ///   - name: The classroom's name.
    ///   - seating: The type of seating in the classroom.
    ///   - capacity: The capacity of the room (number of seatings).
    ///   - additionalInfo: The additional information.
    public init(id: ClassroomID?,
                name: String?,
                seating: Seating?,
                capacity: Int?,
                additionalInfo: String?) {
        self.id = id
        self.name = name
        self.seating = seating
        self.capacity = capacity
        self.additionalInfo = additionalInfo
    }

    private enum CodingKeys: String, CodingKey {
        case id             = "Oid"
        case name           = "DisplayName1"
        case seating        = "SeatingType"
        case capacity       = "Capacity"
        case additionalInfo = "AdditionalInfo"
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container
            .decodeIfPresent(String.self, forKey: .id)?
            .nilIfEmpty
            .flatMap(UUID.init)
            .map(ClassroomID.init)

        name = try container
            .decodeIfPresent(String.self, forKey: .name)?.nilIfEmpty

        seating = try container
            .decodeIfPresent(Int.self, forKey: .seating)
            .flatMap(Seating.init)

        capacity = try container.decodeIfPresent(Int.self, forKey: .capacity)

        additionalInfo = try container
            .decodeIfPresent(String.self, forKey: .additionalInfo)?.nilIfEmpty
    }
}
