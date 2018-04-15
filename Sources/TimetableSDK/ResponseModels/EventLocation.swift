//
//  EventLocation.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 15/04/2018.
//

public struct EventLocation: Equatable, Decodable {

    /// Determines whether the event location is empty.
    public var isEmpty: Bool

    /// The user-facing name of the location.
    public var displayName: String?

    /// The geographic coordinates of the event.
    public var coordinates: Coordinates?

    /// The description of the educators for this location.
    public var educatorsDisplayText: String?

    /// Determines whether the event location contains educators.
    public var hasEducators: Bool

    /// The list of educators' identifiers and names for this location.
    public var educators: [EducatorInfo]

    /// Creates a new event location.
    ///
    /// - Parameters:
    ///   - isEmpty: Determines whether the event location is empty.
    ///   - displayName: The user-facing name of the location.
    ///   - coordinates: The geographic coordinates of the event.
    ///   - coordinatesString: The string representation of the geographic
    ///                        coordinates of the event.
    ///   - educatorsDisplayText: The description of the educators
    ///                           for this location.
    ///   - hasEducators: Determines whether the event location
    ///                   contains educators.
    ///   - educators: The list of educators' identifiers and names
    ///                for this location.
    public init(isEmpty: Bool,
                displayName: String?,
                coordinates: Coordinates?,
                educatorsDisplayText: String?,
                hasEducators: Bool,
                educators: [EducatorInfo]) {

        self.isEmpty = isEmpty
        self.displayName = displayName
        self.coordinates = coordinates
        self.educatorsDisplayText = educatorsDisplayText
        self.hasEducators = hasEducators
        self.educators = educators
    }

    private enum CodingKeys: String, CodingKey {
        case isEmpty                  = "IsEmpty"
        case displayName              = "DisplayName"
        case latitude                 = "Latitude"
        case longitude                = "Longitude"
        case latitudeValue            = "LatitudeValue"
        case longitudeValue           = "LongitudeValue"
        case educatorsDisplayText     = "EducatorsDisplayText"
        case hasEducators             = "HasEducators"
        case educators                = "EducatorIds"
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        displayName =
            try container.decodeIfPresent(String.self, forKey: .displayName)

        let latitude =
            try container.decodeIfPresent(Double.self, forKey: .latitude)

        let longitude =
            try container.decodeIfPresent(Double.self, forKey: .longitude)

        let latitudeString =
            try container.decodeIfPresent(String.self, forKey: .latitudeValue)

        let longitudeString =
            try container.decodeIfPresent(String.self, forKey: .longitudeValue)

        let coordinates = latitude.flatMap { latitude in
            longitude.map { longitude in
                Coordinates(latitude: latitude, longitude: longitude)
            }
        }

        self.coordinates = coordinates ?? latitudeString
            .flatMap { latitudeString in
                Double(latitudeString).flatMap { doubleLatitude in
                    longitudeString
                        .flatMap(Double.init)
                        .map { doubleLongitude in
                            Coordinates(latitude: doubleLatitude,
                                        longitude: doubleLongitude)
                        }
                }
            }

        educatorsDisplayText =
            try container.decodeIfPresent(String.self,
                                          forKey: .educatorsDisplayText)

        let educators = try container
            .decodeIfPresent([EducatorInfo].self,
                             forKey: .educators) ?? []

        self.educators = educators

        hasEducators = try container
                .decodeIfPresent(Bool.self,
                                 forKey: .hasEducators) ?? !educators.isEmpty

        isEmpty = try container
            .decodeIfPresent(Bool.self, forKey: .isEmpty) ?? false
    }
}
