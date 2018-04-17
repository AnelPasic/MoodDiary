//
//  CalendarUseCase.swift
//  Domain
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation
import RxSwift

public protocol CalendarUseCase {
    func notes() -> Observable<[Note]>
    func weekNotes(year: Int, week: Int) -> Observable<[Note]>
    func saveNote(note: Note) -> Observable<Void>
    func deleteNote(note: Note) -> Observable<Void>
}
