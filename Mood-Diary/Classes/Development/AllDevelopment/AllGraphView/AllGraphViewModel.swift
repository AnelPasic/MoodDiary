//
//  AllGraphViewModel.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/26/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Domain
import RxSwift
import RxCocoa

public class AllNote {
    public let year: Int
    public let week: Int
    public let complete: Double
    
    init(year: Int, week: Int, complete: Double) {
        self.year = year
        self.week = week
        self.complete = complete
    }
}
class AllGraphViewModel: ViewModelType {
    
    var useCase: DevelopmentUseCase!
    
    init(with useCase: DevelopmentUseCase) {
        self.useCase = useCase
    }
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        
        let activityIndicator = ActivityIndicator()
        
        let notes = input.year
            .map{ $0 }
            .flatMapLatest { (year) -> SharedSequence<DriverSharingStrategy, (AllNote?, AllNote?, [AllNote])> in
                let weekCount = Date.getLastWeekOfYear(year: year)
                
                let prevNotes = self.useCase.prevAllNotes(year: year)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                
                let nextNotes = self.useCase.nextAllNotes(year: year)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                
                let notes = self.useCase.allNotes(year: year)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                
                return Driver.combineLatest(prevNotes, nextNotes, notes) { (prevNotes, nextNotes, notes) in
                    var allNotes = [AllNote]()
                    if notes.count > 0 {
                        for i in 0..<weekCount {
                            let weekNotes = notes.filter{ $0.week == i + 1 && $0.complete > 0}
                            let weekComplete = weekNotes.map{ $0.complete }.average
                            if weekNotes.count > 0 && weekComplete > 0  {
                                let allNote = AllNote(year: year, week: i + 1, complete: weekComplete)
                                allNotes.append(allNote)
                            }
                        }
                    }
                    
                    var prevNote: AllNote?
                    for note in prevNotes {
                        let weekNotes = prevNotes.filter{ $0.week == note.week && $0.complete > 0 }
                        let weekComplete = weekNotes.map{ $0.complete }.average
                        if weekNotes.count > 0 && weekComplete > 0 {
                            let note = weekNotes.first
                            prevNote = AllNote(year: note!.year, week: note!.week, complete: weekComplete)
                            break
                        }
                    }
                    
                    var nextNote: AllNote?
                    for note in nextNotes {
                        let weekNotes = nextNotes.filter{ $0.week == note.week && $0.complete > 0 }
                        let weekComplete = weekNotes.map{ $0.complete }.average
                        if weekNotes.count > 0 && weekComplete > 0 {
                            let note = weekNotes.first
                            nextNote = AllNote(year: note!.year, week: note!.week, complete: weekComplete)
                            break
                        }
                    }
                    
                    return (prevNote, nextNote, allNotes)
                    }.asDriver()
        }
        
        return Output(result: notes, error: errorTracker.asDriver())
    }
}

extension AllGraphViewModel {
    struct Input {
        let year: Driver<Int>
    }
    
    struct Output {
        let result: Driver<(AllNote?, AllNote?, [AllNote])>
        let error: Driver<Error>
    }
}


