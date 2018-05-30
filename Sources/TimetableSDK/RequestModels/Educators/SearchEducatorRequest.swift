//
//  SearchEducatorRequest.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 30/05/2018.
//

import Foundation

/// Returns a list of educators whose last names (or some part of last names)
/// satisfy the given query.
///
///     GET /api/v1/educators/search/{query}
@available(macOS 10.11, iOS 9.0, tvOS 9.0, watchOS 2.0, *)
public struct SearchEducatorRequest: TimetableDecodableRequestProtocol {

    public var searchQuery: String

    public init(searchQuery: String) {
        self.searchQuery = searchQuery
    }

    public var path: String {
        return "/api/v1/educators/search/\(searchQuery)"
    }

    public typealias Result = Educator.List
}
