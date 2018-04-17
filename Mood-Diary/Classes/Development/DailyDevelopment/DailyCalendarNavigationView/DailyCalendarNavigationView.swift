//
//  DailyCalendarNavigationView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/25/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

protocol DailyCalendarNavigationViewDelegate {
    func nextWeek()
    func prevWeek()
    func today()
    func showCalendar()
}
class DailyCalendarNavigationView: CustomView {

    var delegate: DailyCalendarNavigationViewDelegate?
    
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBAction func nextWeek(_ sender: Any) {
        if delegate != nil {
            delegate?.nextWeek()
        }
    }
    
    @IBAction func prevWeek(_ sender: Any) {
        if delegate != nil {
            delegate?.prevWeek()
        }
    }
    
    @IBAction func today(_ sender: Any) {
        if delegate != nil {
            delegate?.today()
        }
    }
    
    @IBAction func calendarButtonAction(_ sender: Any) {
        if delegate != nil {
            delegate?.showCalendar()
        }
    }
    
    func updateMonth(_ date: Date) {
        let year = date.getYear
        let month = date.getMonthSymbol
        calendarButton.setTitle("\(month). \(year)", for: .normal)
    }
}
