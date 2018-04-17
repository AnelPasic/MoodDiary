//
//  Note.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation

public struct Note {
    public let uid: String
    public let year: Int
    public let week: Int
    public let weekDay: Int
    public let index: Int
    public let desc: String
    public let complete: Int
    
    public init(uid: String, year: Int, week: Int, weekDay: Int, index: Int, desc: String, complete: Int) {
        self.uid = uid
        self.year = year
        self.week = week
        self.weekDay = weekDay
        self.index = index
        self.desc = desc
        self.complete = complete
    }
    
    public init(year: Int, week: Int, weekDay: Int, index: Int, desc: String, complete: Int) {
        let uid = Note.getUID(year: year, week: week, weekDay: weekDay, index: index)
        self.init(uid: uid, year: year, week: week, weekDay: weekDay, index: index, desc: desc, complete: complete)
    }
    
    public init(year: Int, week: Int, weekDay: Int, index: Int) {
        let uid = Note.getUID(year: year, week: week, weekDay: weekDay, index: index)
        self.init(uid: uid, year: year, week: week, weekDay: weekDay, index: index, desc: "", complete: 0)
    }
    
    public static func getUID(year: Int, week: Int, weekDay: Int, index: Int) -> String {
        return "\(year)-\(week)-\(weekDay)-\(index)"
    }
}

extension Note: Equatable {
    public static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.year == rhs.year && lhs.week == rhs.week && lhs.weekDay == rhs.weekDay && lhs.index == rhs.index && lhs.desc == rhs.desc && lhs.complete == rhs.complete
    }
}
