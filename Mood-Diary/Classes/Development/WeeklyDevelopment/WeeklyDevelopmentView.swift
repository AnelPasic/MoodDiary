//
//  WeeklyDevelopmentView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/25/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Domain

class WeeklySelect {
    private var weeklyView: WeeklyDevelopmentView!
    public var week = (Date().getYear, Date().getWeekOfYear) {
        didSet {
            DispatchQueue.main.async {
                self.weeklyView.update()
            }
        }
    }
    
    init(with weeklyView: WeeklyDevelopmentView) {
        self.weeklyView = weeklyView
    }
}

class WeeklyDevelopmentView: BaseContentView {

    
    var developmentView: DevelopmentView!
    var weeklyCalendarPopupView: SelectCalendarPopupView!
    var weeklyChartView: WeeklyGraphView!
    var weeklyCalendarNavigationView: WeeklyCalendarNavigationView!
    var weeklyCalendarView: WeeklyCalendarView!
    var weeklySelect: WeeklySelect!
    
    init(year: Int, week: Int, useCase: DevelopmentUseCase) {
        super.init(frame: .zero)
        weeklySelect = WeeklySelect(with: self)
        
        layoutDevelopment()
        layoutCalendar(year: year, week: week)
        layoutGraph(year: year, week: week, useCase: useCase)
        layoutCalendarPopup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutDevelopment() {
        developmentView = DevelopmentView.layoutDevelopment(self)
    }
    
    func layoutCalendar(year: Int, week: Int) {
        weeklyCalendarNavigationView = WeeklyCalendarNavigationView(frame: .zero)
        weeklyCalendarNavigationView.delegate = self
        developmentView.calendarContainerView.addSubview(weeklyCalendarNavigationView)
        
        weeklyCalendarNavigationView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weeklyCalendarNavigationView.topAnchor.constraint(equalTo: developmentView.calendarContainerView.topAnchor),
            weeklyCalendarNavigationView.leadingAnchor.constraint(equalTo: developmentView.calendarContainerView.leadingAnchor),
            weeklyCalendarNavigationView.trailingAnchor.constraint(equalTo: developmentView.calendarContainerView.trailingAnchor),
            weeklyCalendarNavigationView.heightAnchor.constraint(equalToConstant: 50.0)
            ])
        
        weeklyCalendarView = WeeklyCalendarView(weeklySelect: weeklySelect)
        developmentView.calendarContainerView.addSubview(weeklyCalendarView!)
        
        weeklyCalendarView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weeklyCalendarView!.topAnchor.constraint(equalTo: weeklyCalendarNavigationView.bottomAnchor),
            weeklyCalendarView!.bottomAnchor.constraint(equalTo: developmentView.calendarContainerView.bottomAnchor),
            weeklyCalendarView!.leadingAnchor.constraint(equalTo: developmentView.calendarContainerView.leadingAnchor),
            weeklyCalendarView!.trailingAnchor.constraint(equalTo: developmentView.calendarContainerView.trailingAnchor),
            weeklyCalendarView!.heightAnchor.constraint(equalToConstant: 30.0)
            ])
        
        weeklyCalendarNavigationView.updateWeek(weeklySelect.week)
        weeklyCalendarView?.updateWeekView(weeklySelect.week)
    }
    func layoutGraph(year: Int, week: Int, useCase: DevelopmentUseCase) {
        weeklyChartView = WeeklyGraphView(frame: .zero)
        weeklyChartView.useCase = useCase
        developmentView.chartContainerView.addSubview(weeklyChartView)
        
        weeklyChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weeklyChartView.topAnchor.constraint(equalTo: developmentView.chartContainerView.topAnchor),
            weeklyChartView.bottomAnchor.constraint(equalTo: developmentView.chartContainerView.bottomAnchor),
            weeklyChartView.leadingAnchor.constraint(equalTo: developmentView.chartContainerView.leadingAnchor),
            weeklyChartView.trailingAnchor.constraint(equalTo: developmentView.chartContainerView.trailingAnchor)
            ])
        
        developmentView.gestureView.onSwipe(to: .right) { (gestureRecognizer) in
            self.prevWeek()
        }
        developmentView.gestureView.onSwipe(to: .left) { (gestureRecognizer) in
            self.nextWeek()
        }
        
        weeklyChartView.updateGraph(weeklySelect.week)
    }
    
    func layoutCalendarPopup() {
        weeklyCalendarPopupView = SelectCalendarPopupView(frame: bounds)
        weeklyCalendarPopupView.delegate = self
        weeklyCalendarPopupView.isHidden = true
        
        addSubview(weeklyCalendarPopupView)
        
        weeklyCalendarPopupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weeklyCalendarPopupView.topAnchor.constraint(equalTo: developmentView.topAnchor, constant: 50),
            weeklyCalendarPopupView.bottomAnchor.constraint(equalTo: developmentView.bottomAnchor),
            weeklyCalendarPopupView.leadingAnchor.constraint(equalTo: developmentView.leadingAnchor),
            weeklyCalendarPopupView.trailingAnchor.constraint(equalTo: developmentView.trailingAnchor)
            ])
    }
    
    override func update() {
        let week = weeklySelect.week
        weeklyCalendarView?.updateWeekView(week)
        weeklyChartView.updateGraph(week)
        weeklyCalendarNavigationView.updateWeek(week)
    }
}

extension WeeklyDevelopmentView: WeeklyCalendarNavigationViewDelegate {
    func current() {
        if weeklyCalendarPopupView.isShow {
            weeklyCalendarPopupView.isShow = false
        }
        moveToDate(Date.today())
    }
    
    func prevWeek() {
        if weeklyCalendarPopupView.isShow {
            return
        }
        
        guard let date = Date.getStartDateOfWeek(year: self.weeklySelect.week.0, weekOfYear: self.weeklySelect.week.1) else {
            return
        }
        let prevMon = date.previous(.monday)
        if prevMon.getYear != weeklySelect.week.0 {
            weeklySelect.week = (prevMon.getYear, Date.getLastWeekOfYear(year: prevMon.getYear))
        }
        else {
            weeklySelect.week = (prevMon.getYear, prevMon.getWeekOfYear)
        }
    }
    
    func nextWeek() {
        if weeklyCalendarPopupView.isShow {
            return
        }
        guard let date = Date.getStartDateOfWeek(year: self.weeklySelect.week.0, weekOfYear: self.weeklySelect.week.1) else {
            return
        }
        let nextMon = date.next(.monday)
        if nextMon.getYear != weeklySelect.week.0 {
            weeklySelect.week = (nextMon.getYear, 1)
        }
        else {
            weeklySelect.week = (nextMon.getYear, nextMon.getWeekOfYear)
        }
    }
    
    func showCalendar() {
        guard let date = Date.getStartDateOfWeek(year: self.weeklySelect.week.0, weekOfYear: self.weeklySelect.week.1) else {
            return
        }
        self.weeklyCalendarPopupView.date = date
        self.weeklyCalendarPopupView.isShow = !self.weeklyCalendarPopupView.isShow
    }
}

extension WeeklyDevelopmentView: SelectCalendarPopupViewDelegate {
    func didSelectedDate(_ date: Date) {
        moveToDate(date)
    }
    
    fileprivate func moveToDate(_ date: Date) {
        let year = date.getYear
        let week = date.getWeekOfYear
        if year == weeklySelect.week.0 && week == weeklySelect.week.1 {
            return
        }
        weeklySelect.week = (year, week)
    }
}
