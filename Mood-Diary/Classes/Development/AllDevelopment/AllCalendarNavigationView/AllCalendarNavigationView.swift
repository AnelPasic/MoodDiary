//
//  AllCalendarNavigationView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/26/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

protocol AllCalendarNavigationViewDelegate {
    func nextYear()
    func prevYear()
    func current()
    func showCalendar()
}


class AllCalendarNavigationView: CustomView {
    
    var delegate: AllCalendarNavigationViewDelegate?
    
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
            delegate?.nextYear()
        }
    }
    @IBAction func prevAction(_ sender: Any) {
        if delegate != nil {
            delegate?.prevYear()
        }
    }
    
    func updateYear(_ year: Int) {
        calendarButton.setTitle("\(year)", for: .normal)
    }
}
