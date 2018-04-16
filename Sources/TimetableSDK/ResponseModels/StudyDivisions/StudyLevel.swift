//
//  StudyLevel.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Foundation

/// A study level model. An expample of a study level is "doctoral studies",
/// "master studis", "bachelor studies" etc.
public struct StudyLevel: Decodable, Equatable {

    /// The name of the study level
    public var name: String?

    /// The English name of the study level
    public var englishName: String?

    /// Study program combinations
    public var programs: [Program]

    private enum CodingKeys: String, CodingKey {
        case name        = "StudyLevelName"
        case englishName = "StudyLevelNameEnglish"
        case programs    = "StudyProgramCombinations"
    }

    public init(name: String?,
                englishName: String?,
                combinations: [Program]) {
        self.name = name
        self.englishName = englishName
        self.programs = combinations
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container
            .decodeIfPresent(String.self, forKey: .name)?
            .nilIfEmpty

        englishName = try container
            .decodeIfPresent(String.self, forKey: .englishName)?
            .nilIfEmpty

        programs = try container
            .decodeIfPresent([Program].self, forKey: .programs) ?? []
    }
}
