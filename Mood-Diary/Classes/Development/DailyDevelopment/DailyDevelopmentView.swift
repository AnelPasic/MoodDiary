//
//  DailyDevelopment.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/22/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Sensitive
import Charts
import Domain


class DailySelect {
    private var dailyView: DailyDevelopmentView!
    public var date = Date.today() {
        didSet {
            DispatchQueue.main.async {
                self.dailyView.update()
            }
        }
    }
    
    init(with dailyView: DailyDevelopmentView) {
        self.dailyView = dailyView
    }
}

class DailyDevelopmentView: BaseContentView {

    var developmentView: DevelopmentView!
    var dailyCalendarPopupView: SelectCalendarPopupView!
    var dailyChartView: DailyGraphView!
    var dailyCalendarNavigationView: DailyCalendarNavigationView!
    var dailyCalendarView: DailyCalendarView!
    var dailySelect: DailySelect!
    
    init(year: Int, month: Int, week: Int, useCase: DevelopmentUseCase) {
        super.init(frame: .zero)
        dailySelect = DailySelect(with: self)
        
        layoutDevelopment()
        layoutCalendar(year: year, month: month, week: week)
        layoutGraph(year: year, month: month, week: week, useCase: useCase)
        layoutCalendarPopup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutDevelopment() {
        developmentView = DevelopmentView.layoutDevelopment(self)
    }
    
    func layoutCalendar(year: Int, month: Int, week: Int) {
        dailyCalendarNavigationView = DailyCalendarNavigationView(frame: .zero)
        dailyCalendarNavigationView.delegate = self
        developmentView.calendarContainerView.addSubview(dailyCalendarNavigationView)
        
        dailyCalendarNavigationView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dailyCalendarNavigationView.topAnchor.constraint(equalTo: developmentView.calendarContainerView.topAnchor),
            dailyCalendarNavigationView.leadingAnchor.constraint(equalTo: developmentView.calendarContainerView.leadingAnchor),
            dailyCalendarNavigationView.trailingAnchor.constraint(equalTo: developmentView.calendarContainerView.trailingAnchor),
            dailyCalendarNavigationView.heightAnchor.constraint(equalToConstant: 50.0)
            ])
        
        dailyCalendarView = DailyCalendarView(year: year, month: month, week: week, dailySelect: dailySelect)
        dailyCalendarView?.delegate = self
        developmentView.calendarContainerView.addSubview(dailyCalendarView!)
        
        dailyCalendarView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dailyCalendarView!.topAnchor.constraint(equalTo: dailyCalendarNavigationView.bottomAnchor),
            dailyCalendarView!.bottomAnchor.constraint(equalTo: developmentView.calendarContainerView.bottomAnchor),
            dailyCalendarView!.leadingAnchor.constraint(equalTo: developmentView.calendarContainerView.leadingAnchor),
            dailyCalendarView!.trailingAnchor.constraint(equalTo: developmentView.calendarContainerView.trailingAnchor)
            ])
        
        developmentView.calendarContainerView.onSwipe(to: .right) { (gestureRecognizer) in
            self.prevWeek()
        }
        developmentView.calendarContainerView.onSwipe(to: .left) { (gestureRecognizer) in
            self.nextWeek()
        }
        
        updateMonth()
    }
    func layoutGraph(year: Int, month: Int, week: Int, useCase: DevelopmentUseCase) {
        dailyChartView = DailyGraphView(frame: .zero)
        dailyChartView.useCase = useCase
        developmentView.chartContainerView.addSubview(dailyChartView)
        
        dailyChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dailyChartView.topAnchor.constraint(equalTo: developmentView.chartContainerView.topAnchor),
            dailyChartView.bottomAnchor.constraint(equalTo: developmentView.chartContainerView.bottomAnchor),
            dailyChartView.leadingAnchor.constraint(equalTo: developmentView.chartContainerView.leadingAnchor),
            dailyChartView.trailingAnchor.constraint(equalTo: developmentView.chartContainerView.trailingAnchor)
            ])
        
        developmentView.gestureView.onSwipe(to: .right) { (gestureRecognizer) in
            self.prevDay()
        }
        developmentView.gestureView.onSwipe(to: .left) { (gestureRecognizer) in
            self.nextDay()
        }
    }
    
    func layoutCalendarPopup() {
        dailyCalendarPopupView = SelectCalendarPopupView(frame: bounds)
        dailyCalendarPopupView.isWeek = false
        dailyCalendarPopupView.delegate = self
        dailyCalendarPopupView.isHidden = true

        addSubview(dailyCalendarPopupView)

        dailyCalendarPopupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dailyCalendarPopupView.topAnchor.constraint(equalTo: developmentView.topAnchor, constant: 50),
            dailyCalendarPopupView.bottomAnchor.constraint(equalTo: developmentView.bottomAnchor),
            dailyCalendarPopupView.leadingAnchor.constraint(equalTo: developmentView.leadingAnchor),
            dailyCalendarPopupView.trailingAnchor.constraint(equalTo: developmentView.trailingAnchor)
            ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        dailyCalendarView?.updateLayout()
    }
    
    func prevDay() {
        didSelectedDate(dailySelect.date.getPrevDate!)
    }
    
    func nextDay() {
        didSelectedDate(dailySelect.date.getNextDate!)
    }

    override func update() {
        let date = dailySelect.date
        dailyCalendarView?.updateCalendarView()
        dailyChartView.updateGraph(date)
    }
}

extension DailyDevelopmentView: DailyCalendarNavigationViewDelegate {
    func today() {
        if dailyCalendarPopupView.isShow {
            dailyCalendarPopupView.isShow = false
        }
        didSelectedDate(Date.today())
    }
    
    func prevWeek() {
        if dailyCalendarPopupView.isShow {
            return
        }
        
        dailyCalendarView?.transformWeekViews(true)
    }
    
    func nextWeek() {
        if dailyCalendarPopupView.isShow {
            return
        }
        
        dailyCalendarView?.transformWeekViews(false)
    }
    
    func showCalendar() {
        self.dailyCalendarPopupView.date = dailySelect.date
        self.dailyCalendarPopupView.isShow = !self.dailyCalendarPopupView.isShow
    }
}

extension DailyDevelopmentView: DailyCalendarViewDelegate {
    func updateMonth() {
        guard let date = Date.getStartDateOfWeek(year: self.dailyCalendarView!.currentWeekLabelView!.year, weekOfYear: self.dailyCalendarView!.currentWeekLabelView!.week) else {
            return
        }
        dailyCalendarNavigationView.updateMonth(date)
    }
}

extension DailyDevelopmentView: SelectCalendarPopupViewDelegate {
    func didSelectedDate(_ date: Date) {
        moveToDate(date)
    }
    
    fileprivate func moveToDate(_ date: Date) {
        guard let currentDate = Date.getStartDateOfWeek(year: self.dailyCalendarView!.currentWeekLabelView!.year, weekOfYear: self.dailyCalendarView!.currentWeekLabelView!.week) else {
            return
        }
        let currentYear = currentDate.getYear
        let currentMonth = currentDate.getMonth
        let currentWeek = currentDate.getWeekOfYear
        
        let year = date.getYear
        let month = date.getMonth
        let week = date.getWeekOfYear
        
        if currentYear == year && currentMonth == month && currentWeek == week {
            dailySelect.date = date
            return
        }
        if currentDate < date {
            dailyCalendarView?.updateWeekView(year: year, month: month, week: week, isPrev: false)
            dailyCalendarView?.transformWeekViews(false, date)
        }
        else {
            dailyCalendarView?.updateWeekView(year: year, month: month, week: week, isPrev: true)
            dailyCalendarView?.transformWeekViews(true, date)
        }
    }
}
