//
//  DevelopmentUseCase.swift
//  Domain
//
//  Created by Mobdev125 on 3/24/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

import RxSwift

public protocol DevelopmentUseCase {
    func dailyNotes(year: Int, week: Int, weekDay: Int) -> Observable<[Note]>
    func prevDailyNotes(year: Int, week: Int, weekDay: Int) -> Observable<[Note]>
    func nextDailyNotes(year: Int, week: Int, weekDay: Int) -> Observable<[Note]>
    
    func weeklyNotes(year: Int, week: Int) -> Observable<[Note]>
    func prevWeeklyNotes(year: Int, week: Int) -> Observable<[Note]>
    func nextWeeklyNotes(year: Int, week: Int) -> Observable<[Note]>
    
    func allNotes(year: Int) -> Observable<[Note]>
    func prevAllNotes(year: Int) -> Observable<[Note]>
    func nextAllNotes(year: Int) -> Observable<[Note]>
}
