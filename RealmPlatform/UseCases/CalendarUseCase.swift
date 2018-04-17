//
//  CalendarUseCase.swift
//  RealmPlatform
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import Realm
import RealmSwift

final class CalendarUseCase<Repository>: Domain.CalendarUseCase where Repository: AbstractRepository, Repository.T == Note {
    
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func notes() -> Observable<[Note]> {
        return repository.queryAll()
    }
    func weekNotes(year: Int, week: Int) -> Observable<[Note]> {
        return repository.query(with: NSPredicate(format: "year = %d AND week = %d", year, week), sortDescriptors: [])
    }
    
    func saveNote(note: Note) -> Observable<Void> {
        return repository.save(entity: note)
    }
    
    func deleteNote(note: Note) -> Observable<Void> {
        return repository.delete(entity: note)
    }
}

