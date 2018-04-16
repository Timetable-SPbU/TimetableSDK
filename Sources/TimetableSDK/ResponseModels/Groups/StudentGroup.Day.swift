//
//  StudentGroup.Day.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 15/04/2018.
//

import Foundation

extension StudentGroup {

    public struct Day: Equatable, Decodable {

        /// The day's datetime.
        public var date: Date?

        /// The day's display text.
        public var displayText: String?

        /// The list of events for this day.
        public var events: [StudentGroup.Event]

        /// Creates a new timetable day for a student group.
        ///
        /// - Parameters:
        ///   - date: The day's datetime.
        ///   - displayText: The day's display text.
        ///   - events: The list of events for this day.
        public init(date: Date?,
                    displayText: String?,
                    events: [StudentGroup.Event]) {
            self.date = date
            self.displayText = displayText
            self.events = events
        }

        private enum CodingKeys: String, CodingKey {
            case date        = "Day"
            case displayText = "DayString"
            case events      = "DayStudyEvents"
        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            date = try container
                .decodeIfPresent(String.self, forKey: .date)
                .flatMap(Decoding.fullDateFormatter.date(from:))

            displayText = try container
                .decodeIfPresent(String.self, forKey: .displayText)?
                .nilIfEmpty

            events = try container
                .decodeIfPresent([StudentGroup.Event].self,
                                 forKey: .events) ?? []
        }
    }
}

extension StudentGroup.Day {

    /// A student group's event list for a week.
    public struct List: Equatable, Decodable {

        /// The ID of the student group.
        public var studentGroupID: StudentGroupID?

        /// The name of the student group.
        public var studentGroupDisplayName: String?

        /// The timestamp of 00:00:00 of the previous week Monday
        /// in the timezone specified in the `Decoding.timezone` variable.
        public var previousWeekMonday: Date?

        /// The timestamp of 00:00:00 of the current week Monday
        /// in the timezone specified in the `Decoding.timezone` variable.
        public var currentWeekMonday: Date?

        /// The timestamp of 00:00:00 of the next week Monday
        /// in the timezone specified in the `Decoding.timezone` variable.
        public var nextWeekMonday: Date?

        /// The week's display text.
        public var weekDisplayText: String?

        /// The list of days available for the student group
        /// in the current week.
        public var days: [StudentGroup.Day]

        /// Creates an event list for a student group.
        ///
        /// - Parameters:
        ///   - studentGroupID: The ID of the student group.
        ///   - studentGroupDisplayName: The name of the student group.
        ///   - previouseekMonday: The timestamp of 00:00:00 of
        ///                        the previous week Monday
        ///                        in the current timezone.
        ///   - currentWeekMonday: The timestamp of 00:00:00 of the current week
        ///                        Monday in the timezone specified in
        ///                        the `Decoding.timezone` variable.
        ///   - nextWeekMonday: The timestamp of 00:00:00 of the next week
        ///                     Monday in the timezone specified in
        ///                     the `Decoding.timezone` variable.
        ///   - weekDisplayText: The week's display text.
        ///   - days: The list of days available for the student group
        ///           in the current week.
        public init(studentGroupID: StudentGroupID?,
                    studentGroupDisplayName: String?,
                    previousWeekMonday: Date?,
                    currentWeekMonday: Date?,
                    nextWeekMonday: Date?,
                    weekDisplayText: String?,
                    days: [StudentGroup.Day]) {
            self.studentGroupID = studentGroupID
            self.studentGroupDisplayName = studentGroupDisplayName
            self.previousWeekMonday = previousWeekMonday
            self.currentWeekMonday = currentWeekMonday
            self.nextWeekMonday = nextWeekMonday
            self.weekDisplayText = weekDisplayText
            self.days = days
        }

        private enum CodingKeys: String, CodingKey {
            case studentGroupID          = "StudentGroupId"
            case studentGroupDisplayName = "StudentGroupDisplayName"
            case previousWeekMonday      = "PreviousWeekMonday"
            case currentWeekMonday       = "WeekMonday"
            case nextWeekMonday          = "NextWeekMonday"
            case weekDisplayText         = "WeekDisplayText"
            case days                    = "Days"
        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            studentGroupID = try container
                .decodeIfPresent(StudentGroupID.self, forKey: .studentGroupID)

            studentGroupDisplayName = try container
                .decodeIfPresent(String.self, forKey: .studentGroupDisplayName)?
                .nilIfEmpty

            previousWeekMonday = try container
                .decodeIfPresent(String.self, forKey: .previousWeekMonday)
                .flatMap(Decoding.shortDateFormatter.date(from:))

            currentWeekMonday = try container
                .decodeIfPresent(String.self, forKey: .currentWeekMonday)
                .flatMap(Decoding.shortDateFormatter.date(from:))

            nextWeekMonday = try container
                .decodeIfPresent(String.self, forKey: .nextWeekMonday)
                .flatMap(Decoding.shortDateFormatter.date(from:))

            weekDisplayText = try container
                .decodeIfPresent(String.self, forKey: .weekDisplayText)?
                .nilIfEmpty

            days = try container
                .decodeIfPresent([StudentGroup.Day].self, forKey: .days) ?? []
        }
    }
}
