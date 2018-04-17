//
//  RealmRepresentable.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation

protocol RealmRepresentable {
    associatedtype RealmType: DomainConvertibleType
    
    var uid: String {get}
    
    func asRealm() -> RealmType
}
