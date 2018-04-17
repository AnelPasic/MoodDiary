//
//  DevelopmentUseCase.swift
//  RealmPlatform
//
//  Created by Mobdev125 on 3/24/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Domain
import RxSwift
import Realm
import RealmSwift

final class DevelopmentUseCase<Repository>: Domain.DevelopmentUseCase where Repository: AbstractRepository, Repository.T == Note {
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func dailyNotes(year: Int, week: Int, weekDay: Int) -> Observable<[Note]> {
        return repository.query(with: NSPredicate(format: "year = %d AND week = %d AND weekDay = %d AND complete > 0", year, week, weekDay), sortDescriptors: [])
    }
    
    func prevDailyNotes(year: Int, week: Int, weekDay: Int) -> Observable<[Note]> {
        return repository.query(
            with: NSPredicate(format: "((year = %d AND week = %d AND weekDay < %d) OR (year = %d AND week < %d)) AND year >= %d AND complete > 0", year, week, weekDay, year, week, year - 1),
            sortDescriptors: [
                SortDescriptor.init(keyPath: "year", ascending: false),
                SortDescriptor.init(keyPath: "week", ascending: false),
                SortDescriptor.init(keyPath: "weekDay", ascending: false),
                SortDescriptor.init(keyPath: "index", ascending: false)])
    }
    func nextDailyNotes(year: Int, week: Int, weekDay: Int) -> Observable<[Note]> {
        return repository.query(
            with: NSPredicate(format: "((year = %d AND week = %d AND weekDay > %d) OR (year = %d AND week > %d)) AND year <= %d AND complete > 0", year, week, weekDay, year, week, year + 1),
            sortDescriptors: [
                SortDescriptor.init(keyPath: "year", ascending: true),
                SortDescriptor.init(keyPath: "week", ascending: true),
                SortDescriptor.init(keyPath: "weekDay", ascending: true),
                SortDescriptor.init(keyPath: "index", ascending: true)])
    }
    
    func weeklyNotes(year: Int, week: Int) -> Observable<[Note]> {
        return repository.query(with: NSPredicate(format: "year = %d AND week = %d AND complete > 0", year, week), sortDescriptors: [])
    }
    
    func prevWeeklyNotes(year: Int, week: Int) -> Observable<[Note]> {
        return repository.query(
            with: NSPredicate(format: "(year = %d AND week < %d) AND year >= %d AND complete > 0", year, week, year - 1),
            sortDescriptors: [
                SortDescriptor.init(keyPath: "year", ascending: false),
                SortDescriptor.init(keyPath: "week", ascending: false),
                SortDescriptor.init(keyPath: "weekDay", ascending: false)])
    }
    func nextWeeklyNotes(year: Int, week: Int) -> Observable<[Note]> {
        return repository.query(
            with: NSPredicate(format: "(year = %d AND week > %d) AND year <= %d AND complete > 0", year, week, year + 1),
            sortDescriptors: [
                SortDescriptor.init(keyPath: "year", ascending: true),
                SortDescriptor.init(keyPath: "week", ascending: true),
                SortDescriptor.init(keyPath: "weekDay", ascending: true)])
    }
    
    func allNotes(year: Int) -> Observable<[Note]> {
        return repository.query(with: NSPredicate(format: "year = %d AND complete > 0", year), sortDescriptors: [])
    }
    func prevAllNotes(year: Int) -> Observable<[Note]> {
        return repository.query(
            with: NSPredicate(format: "year = %d AND complete > 0", year - 1),
            sortDescriptors: [
                SortDescriptor.init(keyPath: "year", ascending: false),
                SortDescriptor.init(keyPath: "week", ascending: false)])
    }
    func nextAllNotes(year: Int) -> Observable<[Note]> {
        return repository.query(
            with: NSPredicate(format: "year = %d AND complete > 0", year + 1),
            sortDescriptors: [
                SortDescriptor.init(keyPath: "year", ascending: true),
                SortDescriptor.init(keyPath: "week", ascending: true)])
    }
}


