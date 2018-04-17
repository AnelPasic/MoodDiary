//
//  DailyCalendarView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/22/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

protocol DailyCalendarViewDelegate {
    func updateMonth()
}
class DailyCalendarView: UIView {
    var delegate: DailyCalendarViewDelegate?
    
    var year: Int {
        if self.currentWeekLabelView == nil {
            return 0
        }
        return currentWeekLabelView!.year
    }
    
    var week: Int {
        if self.currentWeekLabelView == nil {
            return 0
        }
        return currentWeekLabelView!.week
    }
    
    var currentWeekLabelView: DailyWeekView?
    var prevWeekLabelView: DailyWeekView?
    var nextWeekLabelView: DailyWeekView?
    var dailySelect: DailySelect?
    
    var isTransforming = false
    
    init(year: Int, month: Int, week: Int, dailySelect: DailySelect) {
        super.init(frame: .zero)
        self.dailySelect = dailySelect
        layoutView(year: year, month: month, week: week)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateLayout() {
        currentWeekLabelView?.transform = CGAffineTransform.identity
        prevWeekLabelView?.transform = CGAffineTransform(translationX: -currentWeekLabelView!.frame.width, y: 0)
        nextWeekLabelView?.transform = CGAffineTransform(translationX: currentWeekLabelView!.frame.width, y: 0)
        self.layoutIfNeeded()
    }
    
    func addWeekLabel(year: Int, month: Int, week: Int, containerView: UIView) -> DailyWeekView{
        let weekLabelView = DailyWeekView(year: year, month: month, week: week, dailySelect: dailySelect!)
        containerView.addSubview(weekLabelView)
        
        weekLabelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weekLabelView.topAnchor.constraint(equalTo: containerView.topAnchor),
            weekLabelView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            weekLabelView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            weekLabelView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        return weekLabelView
    }
    
    func layoutView(year: Int, month: Int, week: Int) {
        prevWeekLabelView = addWeekLabel(year: year, month: month, week: week - 1, containerView: self)
        nextWeekLabelView = addWeekLabel(year: year, month: month, week: week + 1, containerView: self)
        currentWeekLabelView = addWeekLabel(year: year, month: month, week: week, containerView: self)
    }
    
    deinit {
        currentWeekLabelView = nil
        prevWeekLabelView = nil
        nextWeekLabelView = nil
        subviews.forEach{ $0.removeFromSuperview() }
    }
}

extension DailyCalendarView {
    func updateCalendarView() {
        currentWeekLabelView?.updateWeekView()
        prevWeekLabelView?.updateWeekView()
        nextWeekLabelView?.updateWeekView()
    }
    
    func updateWeekView(isPrev: Bool) {
        guard let date = Date.getStartDateOfWeek(year: self.currentWeekLabelView!.year, weekOfYear: self.currentWeekLabelView!.week + (isPrev ? -1:1)) else {
            return
        }
        let year = date.getYear
        let month = date.getMonth
        let week = date.getWeekOfYear
        if isPrev {
            prevWeekLabelView?.update(year: year, month: month, week: week)
            nextWeekLabelView?.update(year: year, month: month, week: week + 2)
        }
        else {
            nextWeekLabelView?.update(year: year, month: month, week: week)
            prevWeekLabelView?.update(year: year, month: month, week: week - 2)
        }
        if delegate != nil {
            delegate?.updateMonth()
        }
    }
    
    func updateWeekView(year: Int, month: Int, week: Int, isPrev: Bool) {
        if isPrev {
            prevWeekLabelView?.update(year: year, month: month, week: week)
        }
        else {
            nextWeekLabelView?.update(year: year, month: month, week: week)
        }
    }
    
    func transformWeekViews(_ isPrev: Bool, _ selectedDate: Date? = nil, _ ratio: Double = 1.0) {
        if isTransforming {
            return
        }
        updateLayout()
        isTransforming = true
        let width = currentWeekLabelView!.superview!.frame.width * (isPrev ? 1 : -1)
        UIView.animate(withDuration: 0.3 * ratio, animations: { [weak self] in
            self?.currentWeekLabelView?.transform = CGAffineTransform(translationX: width, y: 0)
            if isPrev {
                self?.prevWeekLabelView?.transform = CGAffineTransform.identity
            }
            else {
                self?.nextWeekLabelView?.transform = CGAffineTransform.identity
            }
            self?.layoutIfNeeded()
        }) { [weak self] (completed) in
            if isPrev {
                let weekLabelView = self?.nextWeekLabelView
                self?.nextWeekLabelView = self?.currentWeekLabelView
                self?.currentWeekLabelView = self?.prevWeekLabelView
                self?.prevWeekLabelView = weekLabelView
                self?.prevWeekLabelView?.transform = CGAffineTransform(translationX: -width, y: 0)
            }
            else {
                let weekLabelView = self?.prevWeekLabelView
                self?.prevWeekLabelView = self?.currentWeekLabelView
                self?.currentWeekLabelView = self?.nextWeekLabelView
                self?.nextWeekLabelView = weekLabelView
                self?.nextWeekLabelView?.transform = CGAffineTransform(translationX: -width, y: 0)
            }
            self?.updateWeekView(isPrev: isPrev)
            self?.currentWeekLabelView?.superview?.bringSubview(toFront: (self?.currentWeekLabelView)!)
            self?.layoutIfNeeded()
            if selectedDate != nil {
                self?.dailySelect?.date = selectedDate!
                self?.updateCalendarView()
            }
            self?.isTransforming = false
        }
    }
}
