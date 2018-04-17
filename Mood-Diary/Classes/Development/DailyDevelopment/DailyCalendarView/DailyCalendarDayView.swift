//
//  DailyCellButtonView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/23/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class DailyCalendarDayView: UIView {

    var currentDate: Date = Date.today() {
        didSet {
            guard let labelView = weekLabelView, let dayView = weekDayView else {
                return
            }
            labelView.currentDate = currentDate
            dayView.currentDate = currentDate
        }
    }
    
    var weekLabelView: CalendarCellWeekView?
    var weekDayView: DailyCellButtonView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ date: Date, _ dailySelect: DailySelect) {
        super.init(frame: .zero)
        currentDate = date
        layoutView(dailySelect)
    }
    func layoutView(_ dailySelect: DailySelect) {
        let height: CGFloat = Constants.shared.calendarCellHeight
        let lineWidth = Constants.calendarLineWidth
        
        var prevView: UIView? = nil
        for i in 0..<2 {
            var cellView: UIView
            if i == 0 {
                let weekView = CalendarCellWeekView(currentDate, true, false)
                cellView = weekView
                weekLabelView = weekView
            }
            else {
                let dayView = DailyCellButtonView(currentDate, dailySelect)
                cellView = dayView
                weekDayView = dayView
            }
            addSubview(cellView)
            cellView.translatesAutoresizingMaskIntoConstraints = false
            if prevView == nil {
                cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            }
            else {
                cellView.topAnchor.constraint(equalTo: prevView!.bottomAnchor, constant: -lineWidth).isActive = true
            }
            cellView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                cellView.heightAnchor.constraint(equalToConstant: height)
                ])
            
            prevView = cellView
        }
        
        prevView!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    deinit {
        subviews.forEach{ $0.removeFromSuperview() }
    }

    func updateDayView() {
        weekDayView?.updateButton()
    }
}
