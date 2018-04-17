//
//  DailyGraphViewModel.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/24/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Domain
import RxSwift
import RxCocoa

class DailyGraphViewModel: ViewModelType {

    var useCase: DevelopmentUseCase!
    
    init(with useCase: DevelopmentUseCase) {
        self.useCase = useCase
    }
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        
        let activityIndicator = ActivityIndicator()
        
        let notes = input.date
            .map{ $0 }
            .flatMapLatest { (date) -> SharedSequence<DriverSharingStrategy, (Note?, Note?, [Note])> in
                let year = date.getYear
                let week = date.getWeekOfYear
                let weekDay = date.getWeekDay
                
                let prevNotes = self.useCase.prevDailyNotes(year: year, week: week, weekDay: weekDay)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                
                let nextNotes = self.useCase.nextDailyNotes(year: year, week: week, weekDay: weekDay)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                
                let notes = self.useCase.dailyNotes(year: year, week: week, weekDay: weekDay)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                
                return Driver.combineLatest(prevNotes, nextNotes, notes) {
                    return ($0.first, $1.first, $2)
                }.asDriver()
        }
        
        return Output(result: notes, error: errorTracker.asDriver())
    }
}

extension DailyGraphViewModel {
    struct Input {
        let date: Driver<Date>
    }
    
    struct Output {
        let result: Driver<(Note?, Note?, [Note])>
        let error: Driver<Error>
    }
}
