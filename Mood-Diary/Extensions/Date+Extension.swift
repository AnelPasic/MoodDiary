//
//  Date+Extension.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

extension Date {
//    static func getStartOfWeek(year: Int, month: Int, week: Int) -> Int {
//        let components = DateComponents(year: year, month: month, weekOfMonth: week)
//        guard let date = Calendar.gregorian.date(from: components) else {return -1}
//        return Calendar.gregorian.component(.day, from: date)
//    }
    
    static func today() -> Date {
        let today = Date()
        let components = DateComponents(year: today.getYear, month: today.getMonth, day: today.getDay, hour: 0, minute: 0, second: 0, nanosecond: 0)
        return Calendar.gregorian.date(from: components)!
    }
    static func getStartDateOfWeek(year: Int, weekOfYear: Int, isStartMon: Bool = true) -> Date? {
        var components = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year)
        components.weekday = isStartMon ? 2 : 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.gregorian.date(from: components)
    }
    
    static func getStartOfWeek(year: Int, weekOfYear: Int) -> Int {
        var components = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year)
        components.weekday = 2
        components.hour = 0
        components.minute = 0
        components.second = 0
        guard let date = Calendar.gregorian.date(from: components) else {return -1}
        return Calendar.gregorian.component(.day, from: date)
    }
    
    static func getDate(year: Int, weekOfYear: Int, weekDay: Int) -> Date? {
        var components = DateComponents(weekOfYear: weekOfYear  + (weekDay == 7 ? 1:0), yearForWeekOfYear: year)
        components.weekday = (weekDay % 7) + 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.gregorian.date(from: components)
    }
    
    static func isPast(year: Int, weekOfYear: Int, weekDay: Int, index: Int) -> Bool {
        var components = DateComponents(weekOfYear: weekOfYear + (weekDay == 7 ? 1:0), yearForWeekOfYear: year)
        components.weekday = (weekDay % 7) + 1
        components.hour = getHour(index)
        components.minute = 0
        components.second = 0
        guard let date = Calendar.gregorian.date(from: components) else {return false}
        return date < Date()
    }
    
    private static func getHour(_ index: Int) -> Int {
        if index == 1 {
            return 2
        }
        else if index == 2 {
            return 6
        }
        else {
            return index + 4
        }
    }
    
    static func getLastWeekOfYear(year: Int) -> Int {
        guard let date = Date.getStartDateOfWeek(year: year + 1, weekOfYear: 0) else {
            return Int((365.0 / 7.0).rounded())
        }
        
        return date.getWeekOfYear + (date.getDay + 6 == 31 ? 0 : 1)
    }
    
    
    var getWeekOfMonth: Int {
        let week = Calendar.gregorian.component(.weekOfMonth, from: self)
        return week - (self.getWeekDay == 7 ? 1:0)
    }
    
    var getWeekOfYear: Int {
        let week = Calendar.gregorian.component(.weekOfYear, from: self.getPrevDate!)
        if self.getMonth == 12 && week == 1 {
            return Date.getLastWeekOfYear(year: self.getYear)
        }
        return week
    }
    
    
    var getWeekDay: Int {
        let weekDay = Calendar.gregorian.component(.weekday, from: self)
        return (weekDay - 2 + 7) % 7 + 1
    }
    
    var getMonth: Int {
        return Calendar.gregorian.component(.month, from: self)
    }
    
    var getYear: Int {
        return Calendar.gregorian.component(.year, from: self)
    }
    
    var getDay: Int {
        return Calendar.gregorian.component(.day, from: self)
    }
    
    var getPrevDate: Date? {
        return Calendar.gregorian.date(byAdding: .day, value: -1, to: self)
    }
    
    var getNextDate: Date? {
        return Calendar.gregorian.date(byAdding: .day, value: 1, to: self)
    }
    
    var getShortWeekDaySymbol: String {
        let weekDay = Calendar.gregorian.component(.weekday, from: self)
        return DateFormatter().shortWeekdaySymbols[weekDay - 1]
    }
    
    var getVeryShortWeekDaySymbol: String {
        let weekDay = Calendar.gregorian.component(.weekday, from: self)
        return DateFormatter().veryShortWeekdaySymbols[weekDay - 1]
    }
    
    var getMonthSymbol: String {
        let month = Calendar.gregorian.component(.month, from: self)
        return DateFormatter().monthSymbols[month - 1]
    }
    
    var getShortMonthSymbol: String {
        let month = Calendar.gregorian.component(.month, from: self)
        return DateFormatter().shortMonthSymbols[month - 1]
    }
    
    func getDays(from date: Date) -> Int? {
        return Calendar.gregorian.dateComponents([.day], from: date, to: self).day
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}

