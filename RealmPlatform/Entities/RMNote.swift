//
//  Note.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation
import Domain
import RealmSwift
import QueryKit

final class RMNote: Object  {
    @objc dynamic var uid: String = ""
    @objc dynamic var year: Int = 0
    @objc dynamic var week: Int = 0
    @objc dynamic var weekDay: Int = 0
    @objc dynamic var index: Int = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var complete: Int = 0
    
    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension RMNote {
    static var uid: Attribute<String> { return Attribute("uid") }
    static var year: Attribute<Int> { return Attribute("year") }
    static var week: Attribute<Int> { return Attribute("week") }
    static var weekDay: Attribute<Int> { return Attribute("weekDay") }
    static var index: Attribute<Int> { return Attribute("index") }
    static var desc: Attribute<String> { return Attribute("desc") }
    static var complete: Attribute<Int> { return Attribute("complete") }
}

extension RMNote: DomainConvertibleType {
    func asDomain() -> Note {
        return Note(uid: uid, year: year, week: week, weekDay: weekDay, index: index, desc: desc, complete: complete)
    }
}

extension Note: RealmRepresentable {
    func asRealm() -> RMNote {
        return RMNote.build { object in
            object.uid = uid
            object.year = year
            object.week = week
            object.weekDay = weekDay
            object.index = index
            object.desc = desc
            object.complete = complete
        }
    }
}
