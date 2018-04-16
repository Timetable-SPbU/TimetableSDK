//
//  StudentGroup.List.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

extension StudentGroup {

    /// Student groups for the division and the current study year.
    public struct List: Equatable, Decodable {

        /// The ID of the study program.
        public var studyProgramID: StudyProgramID?

        /// Student groups of the study program.
        public var studentGroups: [StudentGroup]

        /// Creates a list of student groups for the given study program ID.
        ///
        /// - Parameters:
        ///   - studyProgramID: The ID of the study program.
        ///   - studentGroups: Student groups of the study program.
        public init(studyProgramID: StudyProgramID?,
                    studentGroups: [StudentGroup]) {
            self.studyProgramID = studyProgramID
            self.studentGroups = studentGroups
        }

        private enum CodingKeys: String, CodingKey {
            case studyProgramID = "Id"
            case studentGroups  = "Groups"
        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            studyProgramID = try container
                .decodeIfPresent(StudyProgramID.self, forKey: .studyProgramID)

            studentGroups = try container
                .decodeIfPresent([StudentGroup].self,
                                 forKey: .studentGroups) ?? []
        }
    }
}
