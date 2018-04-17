//
//  WeeklyCalendarView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/25/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class WeeklyCalendarView: UIView {
    let weekCellWidth: CGFloat = 50.0
    var scrollView: UIScrollView!
    var containerView: UIView!
    var weekButtonViews = [WeeklyCellButtonView]()
    var currentYear: Int!
    var weeklySelect: WeeklySelect!
    var lastTrailingConstraint: NSLayoutConstraint?
    
    init(weeklySelect: WeeklySelect) {
        super.init(frame: .zero)
        currentYear = weeklySelect.week.0
        self.self.weeklySelect = weeklySelect
        layoutView()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        scrollView = UIScrollView(frame: .zero)
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        
        containerView = UIView(frame: .zero)
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
        
        layoutWeeks()
    }
    
    func layoutWeeks() {
        containerView.subviews.forEach{ $0.removeFromSuperview() }
        weekButtonViews.removeAll()
        
        let lastWeek = Date.getLastWeekOfYear(year: currentYear)
        var prevView: UIView? = nil
        for i in 0..<lastWeek {
            prevView = addWeekView(i + 1, prevView: prevView)
        }
        lastTrailingConstraint = prevView!.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        lastTrailingConstraint!.isActive = true
        self.layoutIfNeeded()
        
        updateWeekView(weeklySelect.week)
    }
    
    func addWeekView(_ week: Int, prevView: UIView?) -> WeeklyCellButtonView {
        let lineWidth = Constants.calendarLineWidth
        let weekCellButton = WeeklyCellButtonView.init(weeklySelect)
        containerView.addSubview(weekCellButton)
        
        weekCellButton.translatesAutoresizingMaskIntoConstraints = false
        if prevView == nil {
            weekCellButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        }
        else {
            weekCellButton.leadingAnchor.constraint(equalTo: prevView!.trailingAnchor, constant: -lineWidth).isActive = true
        }
        
        NSLayoutConstraint.activate([
            weekCellButton.widthAnchor.constraint(equalToConstant: weekCellWidth),
            weekCellButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            weekCellButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        weekCellButton.currentWeek = (currentYear, week)
        
        weekButtonViews.append(weekCellButton)
        return weekCellButton
    }

    func updateWeeks() {
        let year = weeklySelect.week.0
        for i in 0..<weekButtonViews.count {
            weekButtonViews[i].currentWeek = (year, i + 1)
        }
        
        let lastWeek = Date.getLastWeekOfYear(year: currentYear)
        if lastWeek == weekButtonViews.count {
            return
        }
        
        lastTrailingConstraint?.isActive = false
        if lastWeek < weekButtonViews.count {
            for i in lastWeek..<weekButtonViews.count {
                weekButtonViews.remove(at: i)
            }
            lastTrailingConstraint = weekButtonViews.last!.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        }
        else {
            var prevView = weekButtonViews.last!
            for i in weekButtonViews.count..<lastWeek {
                prevView = addWeekView(i + 1, prevView: prevView)
            }
            lastTrailingConstraint = prevView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        }
        lastTrailingConstraint?.isActive = true
        self.layoutIfNeeded()
    }
    func updateWeekView(_ week: (Int, Int)) {
        if currentYear != week.0 {
            currentYear = week.0
            updateWeeks()
        }

        let currentView = weekButtonViews[week.1 - 1]
        scrollView.scrollRectToVisible(CGRect(x: currentView.frame.origin.x, y: 0, width: currentView.frame.width * 2, height: 1), animated: true)
        weekButtonViews.forEach{ $0.updateButton() }
    }
}
