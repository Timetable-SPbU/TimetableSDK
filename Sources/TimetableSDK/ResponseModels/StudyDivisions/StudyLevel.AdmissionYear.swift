//
//  StudyLevel.AdmissionYear.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

extension StudyLevel {

    public struct AdmissionYear: Decodable, Equatable {

        public var studyProgramID: StudyProgramID?

        public var number: Int?

        public var isEmpty: Bool

        public var divisionAlias: DivisionAlias?

        private enum CodingKeys: String, CodingKey {
            case studyProgramID = "StudyProgramId"
            case name           = "YearName"
            case number         = "YearNumber"
            case isEmpty        = "IsEmpty"
            case divisionAlias  = "PublicDivisionAlias"
        }

        public init(studyProgramID: StudyProgramID?,
                    number: Int?,
                    isEmpty: Bool,
                    divisionAlias: DivisionAlias?) {
            self.studyProgramID = studyProgramID
            self.number = number
            self.isEmpty = isEmpty
            self.divisionAlias = divisionAlias
        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            studyProgramID = try container
                .decodeIfPresent(StudyProgramID.self, forKey: .studyProgramID)

            let number = try container
                .decodeIfPresent(Int.self, forKey: .number)

            let name = try container
                .decodeIfPresent(String.self, forKey: .name)

            // If `number` or `name` cannot be decoded, we try to produce
            // one from the other.
            self.number = number ?? name.flatMap(Int.init)

            isEmpty = try container
                .decodeIfPresent(Bool.self, forKey: .isEmpty) ?? false

            divisionAlias = try container
                .decodeIfPresent(DivisionAlias.self, forKey: .divisionAlias)
        }
    }
}
