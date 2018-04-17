//
//  YearCellButtonView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/26/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class YearCellButtonView: UIView {

    fileprivate(set) var button = UIButton()
    var font: UIFont = Constants.calendarTextFont!
    var normalTextColor = Constants.calendarTextColor
    let selectedTextColor = UIColor.white
    var allSelect: AllSelect?
    
    var currentYear = Date.today().getYear {
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
                if currentYear == Date.today().getYear {
                    self.button.setTitleColor(selectedTextColor, for: .normal)
                    self.backgroundColor = .red
                }
                else {
                    self.button.setTitleColor(normalTextColor, for: .normal)
                    self.backgroundColor = .clear
                }
            }
            layoutIfNeeded()
        }
    }
    
    init(_ year: Int, _ allSelect: AllSelect) {
        super.init(frame: .zero)
        self.currentYear = year
        self.allSelect = allSelect
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
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        button.addTarget(self, action: #selector(clickHandler), for: .touchUpInside)
    }
    
    @objc func clickHandler() {
        allSelect?.year = currentYear
    }
    
    func updateText() {
        text = "\(currentYear)"
        updateButton()
    }
    
    func updateButton() {
        if currentYear == allSelect!.year {
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
