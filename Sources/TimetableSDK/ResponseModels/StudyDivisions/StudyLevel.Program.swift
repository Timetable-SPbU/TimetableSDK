//
//  StudyLevel.Program.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Foundation

extension StudyLevel {

    /// A study program (aka specialization) model.
    public struct Program: Decodable, Equatable {

        /// The program's name
        public var name: String?

        /// The program's English name
        public var englishName: String?

        /// The list of admission years available for this program
        public var admissionYears: [AdmissionYear]

        private enum CodingKeys: String, CodingKey {
            case name           = "Name"
            case englishName    = "NameEnglish"
            case admissionYears = "AdmissionYears"
        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            name =
                try container.decodeIfPresent(String.self, forKey: .name)

            englishName =
                try container.decodeIfPresent(String.self, forKey: .englishName)

            admissionYears =
                try container.decodeIfPresent([AdmissionYear].self,
                                              forKey: .admissionYears) ?? []
        }
    }
}
