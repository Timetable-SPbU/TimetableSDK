import XCTest
@testable import TimetableSDK

final class TimetableSDKTests: XCTestCase {

    func testDeepServerTraversal() {
        assertNoThrow {
            try fetchDivisions()
        }
    }

    private func fetchDivisions() throws {

        let divisions = try performRequest(DivisionsRequest())

        try divisions.forEach(fetchStudyLevels)
    }

    private func fetchStudyLevels(
        for division: DivisionListItem
    ) throws {

        log("""
            Fetching study levels for division:
            \(generateDeepDescription(division))
            """)

        guard let divisionAlias = division.alias else {
            XCTFail("Division alias is empty, skipping...")
            return
        }

        let request = StudyLevelRequest(divisionAlias: divisionAlias)
        let studyLevels = try performRequest(request)

        try studyLevels.forEach(fetchStudentGroups)
    }

    private func fetchStudentGroups(for studyLevel: StudyLevel) throws {

        log("""
            Fetching study programs for study level:
            \(generateDeepDescription(studyLevel))
            """)

        for program in studyLevel.programs {

            log("""
                Fetching admission years for study program:
                \(generateDeepDescription(program))
                """)

            for admissionYear in program.admissionYears {

                log("""
                    Fetching student groups for admission year:
                    \(generateDeepDescription(admissionYear))
                    """)


                guard let studyProgramID = admissionYear.studyProgramID else {
                    XCTFail("Study program ID is empty, skipping...")
                    continue
                }

                let studentGroupsRequest =
                    StudentGroupsRequest(studydyProgramID: studyProgramID)

                let studentGroupList = try performRequest(studentGroupsRequest)
                try studentGroupList.studentGroups.forEach(fetchEvents)
            }
        }
    }

    private func fetchEvents(for studentGroup: StudentGroup) throws {

        log("""
            Fetching current week events for student group:
            \(generateDeepDescription(studentGroup))
            """)

        guard let studentGroupID = studentGroup.id else {
            XCTFail("Student group ID is empty, skipping...")
            return
        }

        let eventsRequest =
            StudentGroupEventsRequest(studentGroupID: studentGroupID,
                                      timeInterval: .currentWeek)

        _ = try performRequest(eventsRequest)
    }

    func testFetchEducators() {

        guard #available(macOS 10.11, iOS 9.0, tvOS 9.0, watchOS 2.0, *) else {
            return
        }

        assertNoThrow {

            // Emoji query allows to fetch all the educators.
            let result =
                try performRequest(SearchEducatorRequest(searchQuery: "😀"))

            log("\(result.educators.count) educators fetched.")

            XCTAssertGreaterThan(result.educators.count, 0)

            for educator in result.educators {
                XCTAssertNotNil(educator.name?.givenName)
                XCTAssertNotNil(educator.name?.familyName)
            }
        }
    }

    func testFetchAddressesWithClassrooms() {
        assertNoThrow {

            let addresses = try performRequest(AddressesRequest())

            log("\(addresses.count) addresses fetched.")

            XCTAssertGreaterThan(addresses.count, 0)

            for address in addresses {
                XCTAssertNotNil(address.id)
                XCTAssertNotNil(address.name)

                try fetchClassroms(for: address)
            }
        }
    }

    private func fetchClassroms(for address: Address) throws {

        guard let addressID = address.id else {
            XCTFail("Address ID is empty, skipping...")
            return
        }

        let request = ClassroomsRequest(addressID: addressID)
        let classrooms = try performRequest(request)

        log("""
            \(classrooms.count) classrooms fetched for \
            \(address.name ?? "<nil>").
            """)

        XCTAssertGreaterThan(classrooms.count, 0)

        for classroom in classrooms {
            XCTAssertNotNil(classroom.id)
            XCTAssertNotNil(classroom.name)
        }
    }

    func testParsePersonNameComponents() {

        guard #available(macOS 10.11, iOS 9.0, tvOS 9.0, watchOS 2.0, *) else {
            return
        }

        let names: [(short: String, full: String)] = [
            ("Редина-Томас М. А.", "Редина-Томас Марина Андреевна"),
            ("Аббасов М. Э.", "Аббасов Меджид Эльхан оглы"),
            ("Райтманн Ф.", "Райтманн Фолькер"),
            ("Айеле М.", "Айеле Медхин Тефери"),
            ("Авила Реесе Т. А.", "Авила Реесе Татьяна Анатольевна"),
            ("Смит Дж. П.", "Смит Джон Пол"),
            ("Антонов Ф. Ф.", "Антонов Федот Фон Фёдорович")
        ]

        let expectedPNCs: [PersonNameComponents] = [
            .init(firstName: "Марина",
                  middleName: "Андреевна",
                  lastName: "Редина-Томас"),
            .init(firstName: "Меджид",
                  middleName: "Эльхан оглы",
                  lastName: "Аббасов"),
            .init(firstName: "Фолькер",
                  middleName: nil,
                  lastName: "Райтманн"),
            .init(firstName: "Медхин Тефери",
                  middleName: nil,
                  lastName: "Айеле"),
            .init(firstName: "Татьяна",
                  middleName: "Анатольевна",
                  lastName: "Авила Реесе"),
            .init(firstName: "Джон",
                  middleName: "Пол",
                  lastName: "Смит"),
            .init(firstName: "Федот",
                  middleName: "Фон Фёдорович",
                  lastName: "Антонов")
        ]

        for (name, expectation) in zip(names, expectedPNCs) {

            let pnc = PersonNameComponents
                .personNameComponents(fromFullName: name.full,
                                      shortName: name.short)

            XCTAssertEqual(pnc, expectation)
        }
    }

    static var allTests = [
        ("testDeepServerTraversal", testDeepServerTraversal),
        ("testFetchEducators", testFetchEducators),
        ("testParsePersonNameComponents", testParsePersonNameComponents)
    ]
}
