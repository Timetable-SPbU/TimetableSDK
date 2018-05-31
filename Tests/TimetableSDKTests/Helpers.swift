//
//  Helpers.swift
//  TimetableSDKTests
//
//  Created by Sergej Jaskiewicz on 16/04/2018.
//

import Foundation
import TimetableSDK
import SwiftyCurl
import XCTest
import Hammond
#if os(macOS)
import Darwin.C
#else
import Glibc
#endif

extension cURLResponse: ResponseProtocol {

    public var statusCode: HTTPStatusCode {
        return HTTPStatusCode(rawValue: code)
    }

    public var data: Data {
        return rawBody ?? Data()
    }
}

private struct TestError: Error {
    let file: StaticString
    let line: UInt
    let error: Error
}

extension XCTestCase {

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    static func prettyprintedJSON(_ data: Data) -> String {

        do {
            let deserialized = try JSONSerialization
                .jsonObject(with: data)

            let prettyPrinted = try JSONSerialization
                .data(withJSONObject: deserialized, options: .prettyPrinted)

            return String(data: prettyPrinted)!
        } catch {
            return String(data: data)!
        }
    }

    func log(_ item: Any) {
        print(item, terminator: "\n\n")
    }

    func performRequest<Request: TimetableDecodableRequestProtocol>(
        _ request: Request,
        logging: Bool = false,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Request.Result {

        // Sleep for 0.2 seconds to avoid
        // the "Too many requests" error.
        usleep(300000)

        let path = defaultBaseURL.appendingPathComponent(request.path)

        var urlComponents = URLComponents(url: path,
                                          resolvingAgainstBaseURL: false)!

        let query = request.query
        urlComponents.queryItems = query.isEmpty ? nil : query

        let url = urlComponents.url!

        let method = cURLRequestMethod(rawValue: request.method.rawValue)!
        let headers = ["Accept" : "application/json"]

        let curlRequest = cURLRequest(url: url,
                                      method: method,
                                      headers: headers)

        if logging {

            let prettyPrintedRequestHeaders = curlRequest.headers
                .map { "\($0.key): \($0.value)" }
                .joined(separator: ",\n  ")

            let requestLog = """

            Performing request:
            \(request)

            Request URL:
            \(url)

            Request headers:
            {
              \(prettyPrintedRequestHeaders)
            }
            """

            log(requestLog)
        }

        do {
            let connection = cURLConnection(useSSL: false, timeout: 60)
            let response = try connection.request(curlRequest)

            if logging {
                let prettyPrintedResponseHeaders = response.headers
                    .joined(separator: ",\n  ")

                let responseLog = """

                Response status: \(response.statusCode)

                Response headers:
                {
                  \(prettyPrintedResponseHeaders)
                }

                Response body:
                \(XCTestCase.prettyprintedJSON(response.data))

                """

                log(responseLog)
            }

            return try Request.decodeResult(from: response)
        } catch {
            // If logging was turned off and the request failed,
            // we retry the request with logging turned on
            // to see what went wrong.
            if !logging {
                log("Request failed. Retrying with logging turned on...")
                return try performRequest(request, logging: true)
            } else {
                throw TestError(file: file, line: line, error: error)
            }
        }
    }

    func assertNoThrow(_ body: () throws -> Void) {
        do {
            try body()
        } catch let error as TestError {
            XCTFail("An error was thrown:\n\(error.error)",
                    file: error.file,
                    line: error.line)
        } catch {
            fatalError("Unexpected error")
        }
    }
}

@available(macOS 10.11, iOS 9.0, tvOS 9.0, watchOS 2.0, *)
extension PersonNameComponents {

    init(firstName: String?, middleName: String?, lastName: String?) {
        var pnc = PersonNameComponents()
        pnc.givenName = firstName
        pnc.middleName = middleName
        pnc.familyName = lastName
        self = pnc
    }
}
