//
//  Educator.Employment.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 30/05/2018.
//

@available(macOS 10.11, iOS 9.0, tvOS 9.0, watchOS 2.0, *)
extension Educator {

    public struct Employment: Equatable, Decodable {

        public var position: String?

        public var department: String?

        public init(position: String?, department: String?) {
            self.position = position
            self.department = department
        }

        private enum CodingKeys: String, CodingKey {
            case position   = "Position"
            case department = "Department"
        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            position = try container
                .decodeIfPresent(String.self, forKey: .position)?
                .nilIfEmpty

            department = try container
                .decodeIfPresent(String.self, forKey: .department)?
                .nilIfEmpty
        }
    }
}
