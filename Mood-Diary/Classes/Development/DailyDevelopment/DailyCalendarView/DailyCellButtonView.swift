//
//  DailyCellButtonView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/23/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class DailyCellButtonView: UIView {
    
    fileprivate(set) var button = UIButton()
    var font: UIFont = Constants.calendarTextFont!
    let normalTextColor = Constants.calendarTextColor
    let selectedTextColor = UIColor.white
    var dailySelect: DailySelect?
    
    var currentDate: Date = Date.today() {
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
    
    init(_ date: Date, _ dailySelect: DailySelect) {
        super.init(frame: .zero)
        self.currentDate = date
        self.dailySelect = dailySelect
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
        dailySelect?.date = currentDate
    }
    
    func updateText() {
        let day = currentDate.getDay
        if day >= 10 {
            self.text = "\(day)"
        }
        else {
            self.text = "0\(day)"
        }
        
        updateButton()
    }
    
    func updateButton() {
        if currentDate.getYear == dailySelect!.date.getYear &&
            currentDate.getWeekOfYear == dailySelect!.date.getWeekOfYear &&
            currentDate.getDay == dailySelect!.date.getDay {
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
