//
//  FirstViewController.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Sensitive
import PopupDialog
import RxSwift
import RxCocoa
import Domain

class CalendarViewController: UIViewController {
    
    var useCase: CalendarUseCase!
    
    @IBOutlet weak var monthBarView: SelectMonthBarView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var calendarPopupView: SelectCalendarPopupView!
    
    var weekContainerView: UIView?
    
    var currentWeekView: CalendarWeekView?
    var prevWeekView: CalendarWeekView?
    var nextWeekView: CalendarWeekView?
    
    var weekView: CalendarWeekView?
    
    var isTransforming = false
    var firstPanLocation: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthBarView.delegate = self
        layoutView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        weekView?.updateLayout()
    }
    func layoutView() {
        let date = Date.today()
        let year = date.getYear
        let month = date.getMonth
        let week = date.getWeekOfYear
        let margin = Constants.calendarMargin
        let weekView = CalendarWeekView(year: year, month: month, week: week, useCase: useCase)
        containerView.addSubview(weekView)
        
        weekView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weekView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: margin),
            weekView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin),
            weekView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin),
            weekView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -margin)
            ])
        weekView.delegate = self
        self.weekView = weekView
        
        updateMonth()
        calendarPopupView.date = date

//        self.weekContainerView!.onPan(handle: { (gestureRecognizer) in
//            self.handlePans(gestureRecognizer)
//        })

        self.containerView.onSwipe(to: .right) { (gestureRecognizer) in
            self.prevWeek()
        }
        self.containerView.onSwipe(to: .left) { (gestureRecognizer) in
            self.nextWeek()
        }
    }
}

extension CalendarViewController: CalendarWeekViewDelegate {
    func updateMonth() {
        guard let date = Date.getStartDateOfWeek(year: self.weekView!.year, weekOfYear: self.weekView!.week) else {
            return
        }
        let year = date.getYear
        let month = date.getMonthSymbol
        monthBarView.dateButton.setTitle("\(month). \(year)", for: .normal)
    }
}
extension CalendarViewController: SelectMonthBarViewDelegate {
    func selectMonth() {
        guard let date = Date.getStartDateOfWeek(year: self.weekView!.year, weekOfYear: self.weekView!.week) else {
            return
        }
        self.calendarPopupView.date = date
        self.calendarPopupView.isShow = !self.calendarPopupView.isShow
    }
    
    func today() {
        if calendarPopupView.isShow {
            calendarPopupView.date = Date.today()
            return
        }
        
        moveToDate(Date.today())
    }
    
    func moveToDate(_ selectedDate: Date) {
        guard let currentDate = Date.getStartDateOfWeek(year: self.weekView!.year, weekOfYear: self.weekView!.week) else {
            return
        }
        let currentYear = currentDate.getYear
        let currentMonth = currentDate.getMonth
        let currentWeek = currentDate.getWeekOfYear
        
        let year = selectedDate.getYear
        let month = selectedDate.getMonth
        let week = selectedDate.getWeekOfYear
        
        if currentYear == year && currentMonth == month && currentWeek == week {
            return
        }
        if currentDate < selectedDate {
            weekView?.updateWeekView(year: year, month: month, week: week, isPrev: false)
            weekView?.transformWeekViews(false)
        }
        else {
            weekView?.updateWeekView(year: year, month: month, week: week, isPrev: true)
            weekView?.transformWeekViews(true)
        }
    }
    
    func nextWeek() {
        if calendarPopupView.isShow {
            return
        }
        weekView?.transformWeekViews(false)
    }
    func prevWeek() {
        if calendarPopupView.isShow {
            return
        }
        weekView?.transformWeekViews(true)
    }
}

extension CalendarViewController: SelectCalendarPopupViewDelegate {
    func didSelectedDate(_ date: Date) {
        moveToDate(date)
    }
}
