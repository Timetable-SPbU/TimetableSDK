//
//  HTTPResponseProtocol.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

import Foundation

public protocol HTTPResponseProtocol {

    var statusCode: HTTPStatusCode { get }

    var data: Data { get }
}
