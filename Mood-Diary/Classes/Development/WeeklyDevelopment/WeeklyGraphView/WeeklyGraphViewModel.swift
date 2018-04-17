//
//  WeeklyGraphViewModel.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/25/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Domain
import RxSwift
import RxCocoa

public class WeekNote {
    public let year: Int
    public let week: Int
    public let weekDay: Int
    public let complete: Double
    
    init(year: Int, week: Int, weekDay: Int, complete: Double) {
        self.year = year
        self.week = week
        self.weekDay = weekDay
        self.complete = complete
    }
}
class WeeklyGraphViewModel: ViewModelType {
    
    var useCase: DevelopmentUseCase!
    
    init(with useCase: DevelopmentUseCase) {
        self.useCase = useCase
    }
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        
        let activityIndicator = ActivityIndicator()
        
        let notes = input.week
            .map{ $0 }
            .flatMapLatest { (week) -> SharedSequence<DriverSharingStrategy, (WeekNote?, WeekNote?, [WeekNote])> in
                let year = week.0
                let week = week.1
                
                let prevNotes = self.useCase.prevWeeklyNotes(year: year, week: week)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                
                let nextNotes = self.useCase.nextWeeklyNotes(year: year, week: week)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                
                let notes = self.useCase.weeklyNotes(year: year, week: week)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                
                return Driver.combineLatest(prevNotes, nextNotes, notes) { (prevNotes, nextNotes, notes) in
                    var weekNotes = [WeekNote]()
                    if notes.count > 0 {
                        for i in 0..<7 {
                            let dayNotes = notes.filter{ $0.weekDay == (i + 1) % 7 + 1 && $0.complete > 0 }
                            let dayComplete = dayNotes.map{ $0.complete }.average
                            if dayNotes.count > 0 && dayComplete > 0  {
                                let note = dayNotes.first
                                let weekNote = WeekNote(year: note!.year, week: note!.week, weekDay: note!.weekDay, complete: dayComplete)
                                weekNotes.append(weekNote)
                            }
                        }
                    }
                    
                    var prevNote: WeekNote?
                    for note in prevNotes {
                        let dayNotes = prevNotes.filter{ $0.weekDay == note.weekDay && $0.complete > 0 }
                        let dayComplete = dayNotes.map{ $0.complete }.average
                        if dayNotes.count > 0 && dayComplete > 0 {
                            let note = dayNotes.first
                            prevNote = WeekNote(year: note!.year, week: note!.week, weekDay: note!.weekDay, complete: dayComplete)
                            break
                        }
                    }
                    
                    var nextNote: WeekNote?
                    for note in nextNotes {
                        let dayNotes = nextNotes.filter{ $0.weekDay == note.weekDay && $0.complete > 0 }
                        let dayComplete = dayNotes.map{ $0.complete }.average
                        if dayNotes.count > 0 && dayComplete > 0 {
                            let note = dayNotes.first
                            nextNote = WeekNote(year: note!.year, week: note!.week, weekDay: note!.weekDay, complete: dayComplete)
                            break
                        }
                    }
                        
                    return (prevNote, nextNote, weekNotes)
                    }.asDriver()
        }
        
        return Output(result: notes, error: errorTracker.asDriver())
    }
}

extension WeeklyGraphViewModel {
    struct Input {
        let week: Driver<(Int, Int)>
    }
    
    struct Output {
        let result: Driver<(WeekNote?, WeekNote?, [WeekNote])>
        let error: Driver<Error>
    }
}

