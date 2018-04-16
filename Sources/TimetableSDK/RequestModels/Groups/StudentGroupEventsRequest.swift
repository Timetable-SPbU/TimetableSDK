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

    public enum Timetable: Int {
        case all = 0
        case primary
        case attestation
        case final
    }

    /// The student group identifier.
    public var studentGroupID: StudentGroupID

    /// The time interval to fetch the events for.
    public var timeInterval: TimeInterval

    public var timetable: Timetable

    /// Creates a new student group events request.
    ///
    /// - Parameters:
    ///   - studentGroupID: The student group identifier.
    ///   - timeInterval: The time interval to fetch the events for.
    public init(studentGroupID: StudentGroupID,
                timeInterval: TimeInterval = .currentWeek,
                timetable: Timetable = .all) {
        self.studentGroupID = studentGroupID
        self.timeInterval = timeInterval
        self.timetable = timetable
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

    public var query: [URLQueryItem] {
        return [
            URLQueryItem(name: "timetable", value: String(timetable.rawValue))
        ]
    }

    public typealias Result = StudentGroup.Day.List
}
