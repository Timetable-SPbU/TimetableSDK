//
//  StudentGroup.Event.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 15/04/2018.
//

import Foundation

extension StudentGroup {

    public struct Event: Equatable, Decodable {

        /// The date and time when the event begins.
        public var start: Date?

        /// The date and time when the event ends.
        public var end: Date?

        /// The subject of the event.
        public var subject: String?

        /// The time interval of the event (not including the date).
        public var timeIntervalString: String?

        public var dateWithTimeIntervalString: String?

        /// The user-facing representation of the event time interval
        /// (including the date).
        public var displayDateAndTimeIntervalString: String?

        /// The description of the locations where the event takes place.
        public var locationsDisplayText: String?

        /// The description of the educators for this event.
        public var educatorsDisplayText: String?

        /// Determines whether the event has educators.
        public var hasEducators: Bool

        /// Determines whether the event is cancelled.
        public var isCancelled: Bool

        /// Determines whether the event has been assigned after all
        /// the events have been planned.
        public var isAssigned: Bool

        /// Determines whether the event's time was changed.
        public var timeWasChanged: Bool

        /// Determines whether the event's locations were changed.
        public var locationsWereChanged: Bool

        /// Determines whether the event's educators were reassigned.
        public var educatorsWereReassigned: Bool

        public var electiveDisciplinesCount: Int?

        /// Determines whether the event is elective.
        public var isElective: Bool

        /// Determines whether the event is a study event.
        public var isStudy: Bool

        /// Determines whether the event lasts for all day (no time defined).
        public var allDay: Bool

        /// Determines whether event occurs within the same day.
        public var withinTheSameDay: Bool

        /// The list of the event's locations.
        public var eventLocations: [EventLocation]

        /// The list of educators' identifiers and names for this event.
        public var educators: [EducatorInfo]

        /// Creates a new student group event.
        ///
        /// - Parameters:
        ///   - start: The date and time when the event begins.
        ///   - end: The date and time when the event ends.
        ///   - subject: The subject of the event.
        ///   - timeIntervalString: The time interval of the event
        ///                         (not including the date).
        ///   - displayDateAndTimeIntervalString: The user-facing representation
        ///                                       of the event time interval
        ///                                       (including the date).
        ///   - locationsDisplayText: The description of the locations where
        ///                           the event takes place.
        ///   - educatorsDisplayText: The description of the educators
        ///                           for this event.
        ///   - hasEducators: Determines whether the event has educators.
        ///   - isCancelled: Determines whether the event is cancelled.
        ///   - isAssigned: Determines whether the event has been assigned
        ///                 after all the events have been planned.
        ///   - timeWasChanged: Determines whether the event's time was changed.
        ///   - locationsWereChanged: Determines whether the event's locations
        ///                           were changed.
        ///   - educatorsWereReassigned: Determines whether the event's
        ///                              educators were reassigned.
        ///   - isElective: Determines whether the event is elective.
        ///   - isStudy: Determines whether the event is a study event.
        ///   - allDay: Determines whether the event lasts for all day
        ///             (no time defined).
        ///   - withinTheSameDay: Determines whether event occurs
        ///                       within the same day.
        ///   - eventLocations: The list of the event's locations.
        ///   - educators: The list of educators' identifiers and names
        ///                for this event.
        public init(start: Date?,
                    end: Date?,
                    subject: String?,
                    timeIntervalString: String?,
                    dateWithTimeIntervalString: String?,
                    displayDateAndTimeIntervalString: String?,
                    locationsDisplayText: String?,
                    educatorsDisplayText: String?,
                    hasEducators: Bool,
                    isCancelled: Bool,
                    isAssigned: Bool,
                    timeWasChanged: Bool,
                    locationsWereChanged: Bool,
                    educatorsWereReassigned: Bool,
                    electiveDisciplinesCount: Int?,
                    isElective: Bool,
                    isStudy: Bool,
                    allDay: Bool,
                    withinTheSameDay: Bool,
                    eventLocations: [EventLocation],
                    educators: [EducatorInfo]) {
            self.start = start
            self.end = end
            self.subject = subject
            self.timeIntervalString = timeIntervalString
            self.dateWithTimeIntervalString = dateWithTimeIntervalString
            self.displayDateAndTimeIntervalString = displayDateAndTimeIntervalString
            self.locationsDisplayText = locationsDisplayText
            self.educatorsDisplayText = educatorsDisplayText
            self.hasEducators = hasEducators
            self.isCancelled = isCancelled
            self.isAssigned = isAssigned
            self.timeWasChanged = timeWasChanged
            self.locationsWereChanged = locationsWereChanged
            self.educatorsWereReassigned = educatorsWereReassigned
            self.electiveDisciplinesCount = electiveDisciplinesCount
            self.isElective = isElective
            self.isStudy = isStudy
            self.allDay = allDay
            self.withinTheSameDay = withinTheSameDay
            self.eventLocations = eventLocations
            self.educators = educators
        }

        private enum CodingKeys: String, CodingKey {
            case start                            = "Start"
            case end                              = "End"
            case subject                          = "Subject"
            case timeIntervalString               = "TimeIntervalString"
            case dateWithTimeIntervalString       = "DateWithTimeIntervalString"
            case displayDateAndTimeIntervalString
                = "DisplayDateAndTimeIntervalString"
            case locationsDisplayText             = "LocationsDisplayText"
            case educatorsDisplayText             = "EducatorsDisplayText"
            case hasEducators                     = "HasEducators"
            case isCancelled                      = "IsCancelled"
            case isAssigned                       = "IsAssigned"
            case timeWasChanged                   = "TimeWasChanged"
            case locationsWereChanged             = "LocationsWereChanged"
            case educatorsWereReassigned          = "EducatorsWereReassigned"
            case electiveDisciplinesCount         = "ElectiveDisciplinesCount"
            case isElective                       = "IsElective"
            case isStudy                          = "IsStudy"
            case allDay                           = "AllDay"
            case withinTheSameDay                 = "WithinTheSameDay"
            case eventLocations                   = "EventLocations"
            case educators                        = "EducatorIds"
        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            start = try container
                .decodeIfPresent(String.self, forKey: .start)
                .flatMap(Decoding.fullDateFormatter.date(from:))

            end = try container
                .decodeIfPresent(String.self, forKey: .end)
                .flatMap(Decoding.fullDateFormatter.date(from:))

            subject = try container
                .decodeIfPresent(String.self, forKey: .subject)?
                .nilIfEmpty

            timeIntervalString = try container
                .decodeIfPresent(String.self, forKey: .timeIntervalString)?
                .nilIfEmpty

            dateWithTimeIntervalString = try container
                .decodeIfPresent(String.self,
                                 forKey: .dateWithTimeIntervalString)?
                .nilIfEmpty

            displayDateAndTimeIntervalString = try container
                .decodeIfPresent(String.self,
                                 forKey: .displayDateAndTimeIntervalString)?
                .nilIfEmpty

            locationsDisplayText = try container
                .decodeIfPresent(String.self, forKey: .locationsDisplayText)?
                .nilIfEmpty

            educatorsDisplayText = try container
                .decodeIfPresent(String.self, forKey: .educatorsDisplayText)?
                .nilIfEmpty

            isCancelled = try container
                .decodeIfPresent(Bool.self, forKey: .isCancelled) ?? false

            isAssigned = try container
                .decodeIfPresent(Bool.self, forKey: .isAssigned) ?? false

            timeWasChanged = try container
                .decodeIfPresent(Bool.self, forKey: .timeWasChanged) ?? false

            locationsWereChanged = try container
                .decodeIfPresent(Bool.self,
                                 forKey: .locationsWereChanged) ?? false

            educatorsWereReassigned = try container
                .decodeIfPresent(Bool.self,
                                 forKey: .educatorsWereReassigned) ?? false

            electiveDisciplinesCount = try container
                .decodeIfPresent(Int.self, forKey: .electiveDisciplinesCount)

            isElective = try container
                .decodeIfPresent(Bool.self, forKey: .isElective) ?? false

            isStudy = try container
                .decodeIfPresent(Bool.self, forKey: .isStudy) ?? false

            allDay = try container
                .decodeIfPresent(Bool.self, forKey: .allDay) ?? false

            withinTheSameDay = try container
                .decodeIfPresent(Bool.self, forKey: .withinTheSameDay) ?? false

            eventLocations = try container
                .decodeIfPresent([EventLocation].self,
                                 forKey: .eventLocations) ?? []

            let educators = try container
                .decodeIfPresent([EducatorInfo].self, forKey: .educators) ?? []

            self.educators = educators

            hasEducators = try container
                .decodeIfPresent(Bool.self,
                                 forKey: .hasEducators) ?? !educators.isEmpty
        }
    }
}
