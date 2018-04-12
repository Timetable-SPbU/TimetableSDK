//
//  DivisionsRequest.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

/// Returns the list of the available divisions.
///
///     GET /api/v1/study/divisions
public struct DivisionsRequest: TimetableDecodableRequest {

    public init() {}

    // MARK: - TimetableDecodableRequest

    public var path: String { return "/api/v1/study/divisions" }

    public var method: HTTPMethod { return .get }

    public var parameters: [String : Any] { return [:] }

    public typealias Result = [DivisionListItem]
}
