//
//  CalendarCellLabelView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class CalendarCellLabelView: CalendarCellView {

    fileprivate(set) var label = UILabel()
    var font: UIFont = Constants.calendarTextFont!
    var textColor: UIColor = Constants.calendarTextColor {
        didSet {
            label.textColor = textColor
        }
    }
    
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
    override func layoutView() {
        super.layoutView()
        
        layoutLabel()
    }
    
    func layoutLabel() {
        label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.font = font
        label.textColor = textColor
        label.backgroundColor = UIColor.clear
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.widthAnchor.constraint(equalTo: self.widthAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    deinit {
        label.removeFromSuperview()
    }

}
