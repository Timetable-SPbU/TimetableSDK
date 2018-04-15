//
//  StudentGroup.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 12/04/2018.
//

public struct StudentGroup: Equatable, Decodable {

    public var id: StudentGroupID?

    public var name: String?

    public var studyForm: String?

    public var profiles: String?

    public var divisionAlias: DivisionAlias?

    public init(id: StudentGroupID?,
                name: String?,
                studyForm: String?,
                profiles: String?,
                divisionAlias: DivisionAlias?) {
        self.id = id
        self.name = name
        self.studyForm = studyForm
        self.profiles = profiles
        self.divisionAlias = divisionAlias
    }

    private enum CodingKeys: String, CodingKey {
        case id            = "StudentGroupId"
        case name          = "StudentGroupName"
        case studyForm     = "StudentGroupStudyForm"
        case profiles      = "StudentGroupProfiles"
        case divisionAlias = "PublicDivisionAlias"
    }
}
