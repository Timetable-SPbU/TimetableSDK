//
//  TimetableSDK+String.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 16/04/2018.
//

extension String {
    internal var nilIfEmpty: String? {
        return isEmpty ? nil : self
    }
}
