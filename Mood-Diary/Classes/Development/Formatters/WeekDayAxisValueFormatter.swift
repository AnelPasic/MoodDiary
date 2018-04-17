//
//  WeekDayAxisValueFormatter.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/25/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation
import Charts

public class WeekDayAxisValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    public var week: (Int, Int)?
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "E\ndd.MM"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let weekDay = Int(value)
        if week != nil, weekDay > 0 && weekDay <= 7, let date = Date.getDate(year: week!.0, weekOfYear: week!.1, weekDay: weekDay) {
            return dateFormatter.string(from: date)
        }
        else {
            return ""
        }
    }
}

