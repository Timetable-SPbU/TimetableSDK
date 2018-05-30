//
//  TimetableSDK+PersonNameComponents.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 30/05/2018.
//

import Foundation

@available(macOS 10.11, iOS 9.0, tvOS 9.0, watchOS 2.0, *)
extension PersonNameComponents {

    /// Creates `PersonNameComponents` by parsing the provided values.
    ///
    /// - Parameters:
    ///   - fullName: A string of format "Smith John Paul"
    ///   - shortName: A string of format "Smith J. P."
    /// - Returns: A parsed `PersonNameComponents` object.
    internal static func personNameComponents(
        fromFullName fullName: String, shortName: String
    ) -> PersonNameComponents {

        var pnc = PersonNameComponents()

        let components = shortName.components(separatedBy: .whitespaces)

        let lastName = components.filter { !$0.contains(".") }
            .joined(separator: " ")
            .cleanedUp()

        pnc.familyName = lastName

        var firstAndMiddleName = fullName

        guard let lastNameSubrange = fullName.range(of: lastName) else {
            return pnc
        }

        firstAndMiddleName.removeSubrange(lastNameSubrange)
        firstAndMiddleName = firstAndMiddleName
            .trimmingCharacters(in: .whitespaces)

        let initials = components
            .filter { $0.contains(".") }
            .map { String($0.dropLast()) }

        let firstAndMiddleNameComponents = firstAndMiddleName
            .components(separatedBy: .whitespaces)

        let firstNameIndex = initials.first
            .flatMap { firstNameInitial in
                firstAndMiddleNameComponents.index {
                    $0.hasPrefix(firstNameInitial)
                }
        }

        let middleNameIndex: Int? = initials.dropFirst().first
            .flatMap { middleNameInitial in
                firstAndMiddleNameComponents.index {
                    $0.hasPrefix(middleNameInitial)
                }
            }.map {
                $0 == firstNameIndex ? $0 + 1 : $0
        }

        pnc.givenName = firstNameIndex.map { index in
            middleNameIndex.map { firstAndMiddleNameComponents[index..<$0] }
                ?? firstAndMiddleNameComponents[index...]
            }.map { $0.joined(separator: " ") }?.cleanedUp()

        pnc.middleName = middleNameIndex.map {
            firstAndMiddleNameComponents[$0...]
            }.map { $0.joined(separator: " ") }?.cleanedUp()

        return pnc
    }
}
