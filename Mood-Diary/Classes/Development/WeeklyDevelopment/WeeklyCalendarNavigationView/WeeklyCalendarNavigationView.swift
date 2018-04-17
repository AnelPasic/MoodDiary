//
//  DevelopmentCalendarView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/25/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

protocol WeeklyCalendarNavigationViewDelegate {
    func nextWeek()
    func prevWeek()
    func current()
    func showCalendar()
}

class WeeklyCalendarNavigationView: CustomView {
    
    var delegate: WeeklyCalendarNavigationViewDelegate?
    
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBAction func calendarAction(_ sender: Any) {
        if delegate != nil {
            delegate?.showCalendar()
        }
    }
    @IBAction func currentAction(_ sender: Any) {
        if delegate != nil {
            delegate?.current()
        }
    }
    @IBAction func nextAction(_ sender: Any) {
        if delegate != nil {
            delegate?.nextWeek()
        }
    }
    @IBAction func prevAction(_ sender: Any) {
        if delegate != nil {
            delegate?.prevWeek()
        }
    }
    
    func updateWeek(_ week: (Int, Int)) {
        if let date = Date.getStartDateOfWeek(year: week.0, weekOfYear: week.1) {
            calendarButton.setTitle("Week \(week.1) / \(date.getShortMonthSymbol).\(week.0)", for: .normal)
        }
    }
}
