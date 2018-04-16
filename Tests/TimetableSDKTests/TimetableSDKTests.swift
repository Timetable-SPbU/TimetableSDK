import XCTest
import TimetableSDK

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
            log("Division alias is empty, skipping…")
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
                    log("Study program ID is empty, skipping…")
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
            log("Student group ID is empty, skipping…")
            return
        }

        let eventsRequest =
            StudentGroupEventsRequest(studentGroupID: studentGroupID,
                                      timeInterval: .currentWeek)

        _ = try performRequest(eventsRequest)
    }

    static var allTests = [
        ("testDeepServerTraversal", testDeepServerTraversal),
    ]
}
