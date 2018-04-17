//
//  CalendarDayView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Domain

class CalendarDayView: UIView {
    
    var currentDate: Date = Date.today()
    var timeViews: [CalendarCellButtonView]?
    var isUpdatedWeek: Bool = false
    var dayNotes: [Note]! {
        didSet {
            guard let timeViews = self.timeViews, self.dayNotes != nil else {
                return
            }

            let year = currentDate.getYear
            let week = currentDate.getWeekOfYear
            let weekDay = currentDate.getWeekDay
            
            for i in 1..<timeViews.count {
                var note = dayNotes.filter{ $0.index == i }
                if note.count == 0 {
                    let isDeleted = !isUpdatedWeek && timeViews[i].note == nil
                    let note = Note(year: year, week: week, weekDay: weekDay, index: i)
                    timeViews[i].note = note
                    if isDeleted {
                        timeViews[i].type = .deleted
                    }
                    dayNotes.append(note)
                }
                else {
                    timeViews[i].note = note[0]
                }
            }
            updateAverage()
        }
    }
    
    func updateAverage() {
        let average = Int(dayNotes.filter{ $0.complete > 0 }.map{ $0.complete }.average.rounded())
        timeViews![0].type = ButtonType(rawValue: average)!
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(_ date: Date) {
        super.init(frame: .zero)
        currentDate = date
        layoutView()
    }
    func layoutView() {
        let lineWidth = Constants.calendarLineWidth
        
        timeViews = [CalendarCellButtonView]()
        var prevView: UIView? = nil
        for i in 0..<Constants.calendarTimeCount {
            let cellView: CalendarCellButtonView = CalendarCellButtonView(currentDate, i, self)
        
            timeViews!.append(cellView)
            
            addSubview(cellView)
            cellView.translatesAutoresizingMaskIntoConstraints = false
            if prevView == nil {
                cellView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            }
            else {
                cellView.heightAnchor.constraint(equalTo: prevView!.heightAnchor).isActive = true
                cellView.topAnchor.constraint(equalTo: prevView!.bottomAnchor, constant: -lineWidth).isActive = true
            }
            cellView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                ])
            
            prevView = cellView
        }
        
        prevView!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    deinit {
        subviews.forEach{ $0.removeFromSuperview() }
    }
    
    func refreshViews() {
        guard let timeViews = self.timeViews else {
            return
        }
        for timeView in timeViews {
            if timeView.type == .adding || timeView.type == .deleted {
                timeView.type = .none
            }
        }
    }
}

extension CalendarDayView: CalendarCellButtonViewDelegate {
    func updatedNote() {
        updateAverage()
    }
    func refresh() {
        if let weekView = self.superview as? CalendarWeekNotesView {
            weekView.refreshDayViews()
        }
    }
}
