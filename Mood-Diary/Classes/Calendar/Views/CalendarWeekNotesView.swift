//
//  CalendarWeekView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Domain
import RxSwift
import RxCocoa

class CalendarWeekNotesView: UIView {
    
    var useCase: CalendarUseCase!
    var year: Int = 0
    var month: Int = 0
    var week: Int = 0
    
    var dayViews: [CalendarDayView]?
    var disposable: Disposable?
    var isUpdatedWeek: Bool = false
    var weekNotes: [Note]! {
        didSet {
            guard let dayViews = self.dayViews, self.weekNotes != nil else {
                return
            }
            for i in 0..<dayViews.count {
                dayViews[i].isUpdatedWeek = self.isUpdatedWeek
                dayViews[i].dayNotes = weekNotes.filter{ $0.weekDay == (i + 1) }
            }
        }
    }
    
    init(year: Int, month: Int, week: Int, useCase: CalendarUseCase) {
        super.init(frame: .zero)
        self.year = year
        self.month = month
        self.week = week
        self.useCase = useCase
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutView() {
        let lineWidth = Constants.calendarLineWidth
        var prevView: UIView? = nil
        var date = Date.getStartDateOfWeek(year: year, weekOfYear: week, isStartMon: false)
        dayViews = [CalendarDayView]()
        for i in 0..<7 {
            date = date?.getNextDate
            let dayView = CalendarDayView(date!)
            
            addSubview(dayView)
            if i == 0 {
                dayView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            }
            else {
                dayView.leadingAnchor.constraint(equalTo: prevView!.trailingAnchor, constant: -lineWidth).isActive = true
            }
            dayView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dayView.topAnchor.constraint(equalTo: self.topAnchor),
                dayView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
            dayViews!.append(dayView)
            prevView = dayView
        }
        
        prevView!.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dayViews?.forEach{
            if $0 != prevView {
                $0.widthAnchor.constraint(equalTo: prevView!.widthAnchor).isActive = true
            }
        }
        loadWeekNotes(year: year, week: week)
    }
    
    func getDate(_ day: Int) -> Date? {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)
    }
    
    func update(year: Int, month: Int, week: Int) {
        guard let date = Date.getStartDateOfWeek(year: year, weekOfYear: week) else {
            return
        }
        self.year = date.getYear
        self.month = date.getMonth
        self.week = date.getWeekOfYear
        
        var day = Date.getStartOfWeek(year: year, weekOfYear: week)
        for dayView in dayViews! {
            guard let date = getDate(day) else {
                return
            }
            day += 1
            dayView.currentDate = date
        }
        
        loadWeekNotes(year: year, week: week)
    }
    
    deinit {
        if disposable != nil {
            disposable?.dispose()
        }
        dayViews?.removeAll()
        subviews.forEach{ $0.removeFromSuperview() }
    }
    
    func loadWeekNotes(year: Int, week: Int) {
        guard let useCase = self.useCase else {
            return
        }
        
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        if self.disposable != nil {
            self.disposable?.dispose()
        }
        isUpdatedWeek = true
        self.disposable = useCase.weekNotes(year: year, week: week)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] notes in
                self.weekNotes = notes
                self.isUpdatedWeek = false
            })
    }
    
    func refreshDayViews() {
        guard let dayViews = self.dayViews else {
            return
        }
        
        for dayView in dayViews {
            dayView.refreshViews()
        }
    }
}
