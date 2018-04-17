//
//  CalendarWeekLabelView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/22/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class CalendarWeekLabelView: UIView {
    
    var year: Int = 0
    var month: Int = 0
    var week: Int = 0
    
    var dayLabelViews: [CalendarDayLabelView]?
    
    init(year: Int, month: Int, week: Int, isCalendar: Bool = true) {
        super.init(frame: .zero)
        self.year = year
        self.month = month
        self.week = week
        layoutView(isCalendar: isCalendar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutView(isCalendar: Bool = true) {
        let lineWidth = Constants.calendarLineWidth
        var prevView: UIView? = nil
        var date = Date.getStartDateOfWeek(year: year, weekOfYear: week, isStartMon: false)
        dayLabelViews = [CalendarDayLabelView]()
        for i in 0..<7 {
            date = date?.getNextDate
            let dayView = CalendarDayLabelView(date!, isCalendar)
            
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
            dayLabelViews!.append(dayView)
            prevView = dayView
        }
        
        prevView!.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dayLabelViews?.forEach{
            if $0 != prevView {
                $0.widthAnchor.constraint(equalTo: prevView!.widthAnchor).isActive = true
            }
        }
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
        for dayView in dayLabelViews! {
            guard let date = getDate(day) else {
                return
            }
            day += 1
            dayView.currentDate = date
        }
    }
    
    deinit {
        dayLabelViews?.removeAll()
        subviews.forEach{ $0.removeFromSuperview() }
    }
}
