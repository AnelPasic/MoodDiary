//
//  WeeklyCellButtonView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/25/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class WeeklyCellButtonView: CalendarCellView {
    
    fileprivate(set) var button = UIButton()
    var font: UIFont = Constants.calendarTextFont!
    let normalTextColor = Constants.calendarTextColor
    let selectedTextColor = UIColor.white
    var weeklySelect: WeeklySelect?
    
    var currentWeek = (Date().getYear, Date().getWeekOfYear) {
        didSet {
            updateText()
        }
    }
    
    var text: String = "" {
        didSet {
            button.setTitle(text, for: .normal)
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                self.button.setTitleColor(selectedTextColor, for: .normal)
                self.backgroundColor = Constants.appColor
            }
            else {
                self.button.setTitleColor(normalTextColor, for: .normal)
                self.backgroundColor = .clear
            }
            layoutIfNeeded()
        }
    }
    
    init(_ weeklySelect: WeeklySelect) {
        super.init(frame: .zero)
        self.weeklySelect = weeklySelect
        layoutButton()
        updateText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutButton() {
        button = UIButton(frame: bounds)
        button.titleLabel?.font = font
        button.setTitleColor(Constants.calendarTextColor, for: .normal)
        button.backgroundColor = UIColor.clear
        addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.widthAnchor.constraint(equalTo: self.widthAnchor),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        button.addTarget(self, action: #selector(clickHandler), for: .touchUpInside)
    }
    
    @objc func clickHandler() {
        if weeklySelect!.week.0 == currentWeek.0 && weeklySelect!.week.1 == currentWeek.1 {
            return
        }
        weeklySelect?.week = currentWeek
    }
    
    func updateText() {
        self.text = "\(currentWeek.1)"
        
        updateButton()
    }
    
    func updateButton() {
        if currentWeek.0 == weeklySelect?.week.0 &&
            currentWeek.1 == weeklySelect?.week.1 {
            self.isSelected = true
        }
        else {
            self.isSelected = false
        }
    }
    
    deinit {
        button.removeFromSuperview()
    }
    
}
