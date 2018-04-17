//
//  SelectCalendarPopupViewController.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import FSCalendar

@objc protocol SelectCalendarPopupViewDelegate {
    func didSelectedDate(_ date: Date)
}

@IBDesignable
class SelectCalendarPopupView: CustomView {
    
    @IBOutlet weak var delegate: SelectCalendarPopupViewDelegate?

    @IBOutlet weak var calendarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarView: FSCalendar!
    
    var isProcessing: Bool = false
    var isWeek: Bool = true {
        didSet {
            calendarView.allowsMultipleSelection = isWeek
        }
    }
    var date: Date = Date.today() {
        didSet {
            self.selectWeek(date)
        }
    }
    
    var isShow: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.isHidden = !self.isShow
                if self.calendarTopConstraint != nil {
                    self.calendarTopConstraint.isActive = false
                }
                if self.isShow {
                    self.calendarTopConstraint = self.calendarView.topAnchor.constraint(equalTo: self.calendarView.superview!.topAnchor)
                    self.calendarTopConstraint.isActive = true
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        guard let contentView = self.view else {
            return
        }
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 5
        
        backgroundColor = .clear
        calendarTopConstraint.isActive = false
    }

    @IBAction func tapHandler(_ sender: Any) {
        self.isShow = false
    }
    
    func selectWeek(_ date: Date) {
        if !isWeek {
            calendarView.select(date, scrollToDate: true)
            return
        }
        
        calendarView.selectedDates.forEach{ calendarView.deselect($0) }
        let mon = date.previous(.monday, considerToday: true)
        calendarView.select(mon, scrollToDate: false)
        calendarView.select(mon.next(.tuesday), scrollToDate: false)
        calendarView.select(mon.next(.wednesday), scrollToDate: false)
        calendarView.select(mon.next(.thursday), scrollToDate: false)
        calendarView.select(mon.next(.friday), scrollToDate: false)
        calendarView.select(mon.next(.saturday), scrollToDate: false)
        calendarView.select(mon.next(.sunday), scrollToDate: true)
        calendarView.reloadData()
    }
    
    func didSelectedDate(_ date: Date) {
        isShow = false
        if delegate != nil {
            delegate?.didSelectedDate(date)
        }
    }
}

extension SelectCalendarPopupView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if isProcessing {
            return
        }
        isProcessing = true
        selectWeek(date)
        didSelectedDate(date)
        isProcessing = false
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if isProcessing {
            return
        }
        isProcessing = true
        isShow = false
        isProcessing = false
    }
}
