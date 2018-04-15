//
//  StudentGroupsRequest.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Hammond

/// Returns the list of student groups for the division and
/// the current study year.
///
///     GET /api/v1/progams/{id}/groups
public struct StudentGroupsRequest: TimetableDecodableRequestProtocol {

    public var studyProgramID: StudyProgramID

    public init(studydyProgramID: StudyProgramID) {
        self.studyProgramID = studydyProgramID
    }

    public var path: String {
        return "/api/v1/progams/\(studyProgramID)/groups"
    }

    public typealias Result = StudentGroup.List
}
