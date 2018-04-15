//
//  Decoding.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 15/04/2018.
//

import Foundation

public struct Decoding {

    internal static let decoder = JSONDecoder()

    internal static let shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = .posix
        return dateFormatter
    }()

    internal static let fullDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = .posix
        return dateFormatter
    }()

    private static var _timezone: TimeZone? {
        didSet {
            shortDateFormatter.timeZone = _timezone
            fullDateFormatter.timeZone = _timezone
        }
    }

    /// The timezone to use when decoding the dates. Must be set once.
    /// This global variable is not thread-safe.
    public static var timezone: TimeZone {
        get {
            return _timezone ?? .current
        }
        set {
            if _timezone == nil {
                _timezone = newValue
            } else {
                preconditionFailure("The timezone must be set once.")
            }
        }
    }
}
