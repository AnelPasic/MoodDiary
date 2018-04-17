//
//  CalendarCellWeekView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class CalendarCellWeekView: CalendarCellLabelView {

    var currentDate: Date = Date.today() {
        didSet {
            self.updateView()
        }
    }
    var isWeekName = true
    var isCalendar = true
    var weekDay: String {
        if isWeekName {
            if isCalendar {
                return currentDate.getShortWeekDaySymbol
            }
            else {
                return currentDate.getVeryShortWeekDaySymbol
            }
        }
        else {
            let day = currentDate.getDay
            if day >= 10 {
                return "\(day)"
            }
            else {
                return "0\(day)"
            }
        }
    }
    
    init(_ date: Date, _ isWeekName: Bool, _ isCalendar: Bool = true) {
        super.init(frame: .zero)
        self.isWeekName = isWeekName
        self.isCalendar = isCalendar
        currentDate = date
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateView() {
        if !isCalendar {
            borderColor = .clear
            borderWidth = 0
        }
        if isCalendar && Calendar.gregorian.isDateInToday(currentDate) {
            backgroundColor = Constants.calendarLineColor
            textColor = .white
        }
        else {
            backgroundColor = .white
            textColor = Constants.calendarTextColor
        }
        self.text = weekDay
    }
}
