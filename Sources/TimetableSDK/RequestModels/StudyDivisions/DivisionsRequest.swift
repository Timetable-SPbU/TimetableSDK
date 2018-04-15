//
//  DivisionsRequest.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

/// Returns the list of the available divisions.
///
///     GET /api/v1/study/divisions
public struct DivisionsRequest: TimetableDecodableRequestProtocol {

    public init() {}

    // MARK: - TimetableDecodableRequest

    public var path: String { return "/api/v1/study/divisions" }

    public typealias Result = [DivisionListItem]
}
