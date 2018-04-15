//
//  StudyLevelRequest.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

/// Returns the list of study levels with study programs for the division.
///
///     GET /api/v1/study/divisions/{alias}/programs/levels
public struct StudyLevelRequest: TimetableDecodableRequestProtocol {

    /// The division's short name code (alias)
    public var divisionAlias: DivisionAlias

    /// Creates a study levels request for the provieded division.
    ///
    /// - Parameter divisionAlias: The division's short name code (alias)
    public init(divisionAlias: DivisionAlias) {
        self.divisionAlias = divisionAlias
    }

    public var path: String {
        return "/api/v1/study/divisions/\(divisionAlias)/programs/levels"
    }

    public typealias Result = [StudyLevel]
}
