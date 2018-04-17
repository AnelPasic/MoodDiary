//
//  CalendarWeekView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/23/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Domain

protocol CalendarWeekViewDelegate {
    func updateMonth()
}

class CalendarWeekView: UIView {
    var delegate: CalendarWeekViewDelegate?
    
    var year: Int {
        if self.currentWeekView == nil {
            return 0
        }
        return currentWeekView!.year
    }
    
    var week: Int {
        if self.currentWeekView == nil {
            return 0
        }
        return currentWeekView!.week
    }
    
    var timeLeftView: CalendarTimeLeftView?
    
    var currentWeekView: CalendarWeekNotesView?
    var prevWeekView: CalendarWeekNotesView?
    var nextWeekView: CalendarWeekNotesView?
    
    var currentWeekLabelView: CalendarWeekLabelView?
    var prevWeekLabelView: CalendarWeekLabelView?
    var nextWeekLabelView: CalendarWeekLabelView?
    
    var isTransforming = false
    
    init(year: Int, month: Int, week: Int, useCase: CalendarUseCase) {
        super.init(frame: .zero)
        layoutView(year: year, month: month, week: week, useCase: useCase)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateLayout() {
        currentWeekLabelView?.transform = CGAffineTransform.identity
        prevWeekLabelView?.transform = CGAffineTransform(translationX: -currentWeekLabelView!.frame.width, y: 0)
        nextWeekLabelView?.transform = CGAffineTransform(translationX: currentWeekLabelView!.frame.width, y: 0)

        currentWeekView?.transform = CGAffineTransform.identity
        prevWeekView?.transform = CGAffineTransform(translationX: -currentWeekView!.frame.width, y: 0)
        nextWeekView?.transform = CGAffineTransform(translationX: currentWeekView!.frame.width, y: 0)
        self.layoutIfNeeded()
    }
    func addWeekLabel(year: Int, month: Int, week: Int, containerView: UIView) -> CalendarWeekLabelView{
        let weekLabelView = CalendarWeekLabelView(year: year, month: month, week: week)
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
    
    func addWeekView(year: Int, month: Int, week: Int, containerView: UIView, useCase: CalendarUseCase) -> CalendarWeekNotesView{
        let weekView = CalendarWeekNotesView(year: year, month: month, week: week, useCase: useCase)
        containerView.addSubview(weekView)
        
        weekView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weekView.topAnchor.constraint(equalTo: containerView.topAnchor),
            weekView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            weekView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            weekView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            ])
        return weekView
    }
    
    func layoutView(year: Int, month: Int, week: Int, useCase: CalendarUseCase) {
        let lineWidth = Constants.calendarLineWidth
        
        let emptyView = UIView(frame: .zero)
        addSubview(emptyView)
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            emptyView.topAnchor.constraint(equalTo: self.topAnchor)
            ])
        
        let weekLabelContainerView = CalendarCellView(frame: .zero)
        weekLabelContainerView.clipsToBounds = true
        addSubview(weekLabelContainerView)
        
        weekLabelContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weekLabelContainerView.leadingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -lineWidth),
            weekLabelContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            weekLabelContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            weekLabelContainerView.heightAnchor.constraint(equalTo: emptyView.heightAnchor),
            weekLabelContainerView.widthAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 7, constant: 0)
            ])
        
        currentWeekLabelView = addWeekLabel(year: year, month: month, week: week, containerView: weekLabelContainerView)
        prevWeekLabelView = addWeekLabel(year: year, month: month, week: week - 1, containerView: weekLabelContainerView)
        nextWeekLabelView = addWeekLabel(year: year, month: month, week: week + 1, containerView: weekLabelContainerView)
        
        let scrollContainerView = CalendarCellView(frame: .zero)
        scrollContainerView.clipsToBounds = true
        addSubview(scrollContainerView)
        
        scrollContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollContainerView.topAnchor.constraint(equalTo: weekLabelContainerView.bottomAnchor, constant: -lineWidth)
            ])
        
        let weekScrollView = UIScrollView(frame: .zero)
        weekScrollView.clipsToBounds = true
        scrollContainerView.addSubview(weekScrollView)
        
        weekScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weekScrollView.leadingAnchor.constraint(equalTo: scrollContainerView.leadingAnchor),
            weekScrollView.trailingAnchor.constraint(equalTo: scrollContainerView.trailingAnchor),
            weekScrollView.bottomAnchor.constraint(equalTo: scrollContainerView.bottomAnchor),
            weekScrollView.topAnchor.constraint(equalTo: scrollContainerView.topAnchor)
            ])
        
        let containerView = CalendarCellView(frame: .zero)
        containerView.clipsToBounds = true
        weekScrollView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: weekScrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: weekScrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: weekScrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: weekScrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
        
        let leftTimeView = CalendarTimeLeftView(frame: .zero)
        containerView.addSubview(leftTimeView)
        
        leftTimeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftTimeView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            leftTimeView.topAnchor.constraint(equalTo: containerView.topAnchor),
            leftTimeView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        let weekContainerView = CalendarCellView(frame: .zero)
        weekContainerView.clipsToBounds = true
        containerView.addSubview(weekContainerView)
        
        weekContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weekContainerView.leadingAnchor.constraint(equalTo: leftTimeView.trailingAnchor, constant: -lineWidth),
            weekContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            weekContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            weekContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            weekContainerView.widthAnchor.constraint(equalTo: leftTimeView.widthAnchor, multiplier: 7, constant: 0)
            ])
        
        currentWeekView = addWeekView(year: year, month: month, week: week, containerView: weekContainerView, useCase: useCase)
        prevWeekView = addWeekView(year: year, month: month, week: week - 1, containerView: weekContainerView, useCase: useCase)
        nextWeekView = addWeekView(year: year, month: month, week: week + 1, containerView: weekContainerView, useCase: useCase)
    }
    
    deinit {
        timeLeftView = nil
        
        currentWeekView = nil
        prevWeekView = nil
        nextWeekView = nil
        
        currentWeekLabelView = nil
        prevWeekLabelView = nil
        nextWeekLabelView = nil
        subviews.forEach{ $0.removeFromSuperview() }
    }
}

extension CalendarWeekView {
    func updateWeekView(isPrev: Bool) {
        guard let date = Date.getStartDateOfWeek(year: self.currentWeekView!.year, weekOfYear: self.currentWeekView!.week + (isPrev ? -1:1)) else {
            return
        }
        let year = date.getYear
        let month = date.getMonth
        let week = date.getWeekOfYear
        if isPrev {
            prevWeekLabelView?.update(year: year, month: month, week: week)
            prevWeekView?.update(year: year, month: month, week: week)
            nextWeekLabelView?.update(year: year, month: month, week: week + 2)
            nextWeekView?.update(year: year, month: month, week: week + 2)
        }
        else {
            nextWeekLabelView?.update(year: year, month: month, week: week)
            nextWeekView?.update(year: year, month: month, week: week)
            prevWeekLabelView?.update(year: year, month: month, week: week - 2)
            prevWeekView?.update(year: year, month: month, week: week - 2)
        }
        if delegate != nil {
            delegate?.updateMonth()
        }
    }
    
    func updateWeekView(year: Int, month: Int, week: Int, isPrev: Bool) {
        if isPrev {
            prevWeekLabelView?.update(year: year, month: month, week: week)
            prevWeekView?.update(year: year, month: month, week: week)
        }
        else {
            nextWeekLabelView?.update(year: year, month: month, week: week)
            nextWeekView?.update(year: year, month: month, week: week)
        }
    }
    
    func transformWeekViews(_ isPrev: Bool, _ ratio: Double = 1.0) {
        if isTransforming {
            return
        }
        isTransforming = true
        let width = currentWeekView!.superview!.frame.width * (isPrev ? 1 : -1)
        UIView.animate(withDuration: 0.3 * ratio, animations: { [weak self] in
            self?.currentWeekLabelView?.transform = CGAffineTransform(translationX: width, y: 0)
            self?.currentWeekView?.transform = CGAffineTransform(translationX: width, y: 0)
            if isPrev {
                self?.prevWeekLabelView?.transform = CGAffineTransform.identity
                self?.prevWeekView?.transform = CGAffineTransform.identity
            }
            else {
                self?.nextWeekLabelView?.transform = CGAffineTransform.identity
                self?.nextWeekView?.transform = CGAffineTransform.identity
            }
            self?.layoutIfNeeded()
        }) { [weak self] (completed) in
            if isPrev {
                let weekView = self?.nextWeekView
                self?.nextWeekView = self?.currentWeekView
                self?.currentWeekView = self?.prevWeekView
                self?.prevWeekView = weekView
                self?.prevWeekView?.transform = CGAffineTransform(translationX: -width, y: 0)
                
                let weekLabelView = self?.nextWeekLabelView
                self?.nextWeekLabelView = self?.currentWeekLabelView
                self?.currentWeekLabelView = self?.prevWeekLabelView
                self?.prevWeekLabelView = weekLabelView
                self?.prevWeekLabelView?.transform = CGAffineTransform(translationX: -width, y: 0)
            }
            else {
                let weekView = self?.prevWeekView
                self?.prevWeekView = self?.currentWeekView
                self?.currentWeekView = self?.nextWeekView
                self?.nextWeekView = weekView
                self?.nextWeekView?.transform = CGAffineTransform(translationX: -width, y: 0)
                
                let weekLabelView = self?.prevWeekLabelView
                self?.prevWeekLabelView = self?.currentWeekLabelView
                self?.currentWeekLabelView = self?.nextWeekLabelView
                self?.nextWeekLabelView = weekLabelView
                self?.nextWeekLabelView?.transform = CGAffineTransform(translationX: -width, y: 0)
            }
            self?.updateWeekView(isPrev: isPrev)
            self?.currentWeekView?.superview?.bringSubview(toFront: (self?.currentWeekView)!)
            self?.currentWeekLabelView?.superview?.bringSubview(toFront: (self?.currentWeekLabelView)!)
            self?.layoutIfNeeded()
            self?.isTransforming = false
        }
    }
}
