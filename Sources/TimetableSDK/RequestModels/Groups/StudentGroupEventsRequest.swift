//
//  StudentGroupEventsRequest.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 15/04/2018.
//

import Foundation

/// Gets a given student group's events for a given time interval.
///
///     GET /api/v1/groups/{id}/events
/// or
///
///     GET /api/v1/groups/{id}/events/{from}
/// or
///
///     GET /api/v1/groups/{id}/events/{from}/{to}
public struct StudentGroupEventsRequest: TimetableDecodableRequestProtocol {

    public enum TimeInterval {
        case currentWeek
        case from(Date)
        case range(from: Date, to: Date)
    }

    /// The student group identifier.
    public var studentGroupID: StudentGroupID

    /// The time interval to fetch the events for.
    public var timeInterval: TimeInterval

    /// Creates a new student group events request.
    ///
    /// - Parameters:
    ///   - studentGroupID: The student group identifier.
    ///   - timeInterval: The time interval to fetch the events for.
    public init(studentGroupID: StudentGroupID, timeInterval: TimeInterval) {
        self.studentGroupID = studentGroupID
        self.timeInterval = timeInterval
    }

    public var path: String {

        let defaultPath = "/api/v1/groups/\(studentGroupID)/events"

        switch timeInterval {
        case .currentWeek:
            return defaultPath
        case .from(let start):
            let startString = Decoding.shortDateFormatter.string(from: start)
            return defaultPath + "/\(startString)"
        case .range(from: let start, to: let end):
            let startString = Decoding.shortDateFormatter.string(from: start)
            let endString = Decoding.shortDateFormatter.string(from: end)
            return defaultPath + "/\(startString)/\(endString)"
        }
    }

    public typealias Result = StudentGroup.Day.List
}
