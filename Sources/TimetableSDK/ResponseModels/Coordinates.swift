//
//  Coordinates.swift
//  Hammond
//
//  Created by Sergej Jaskiewicz on 15/04/2018.
//

import Foundation

public struct Coordinates: Equatable {

    public var latitude: Double

    public var longitude: Double

    public init(latitude: Double,
                longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
