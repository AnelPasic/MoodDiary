//
//  CalendarTimeLeftView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class CalendarTimeLeftView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        let height: CGFloat = Constants.shared.calendarCellHeight
        let lineWidth = Constants.calendarLineWidth
        
        var prevView: UIView? = nil
        for i in 0..<Constants.calendarTimeCount {
            let labelView = CalendarCellLabelView(frame: CGRect.zero)
            labelView.text = getLabelString(i)
            addSubview(labelView)
            
            labelView.translatesAutoresizingMaskIntoConstraints = false
            if prevView == nil {
                labelView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            }
            else {
                labelView.topAnchor.constraint(equalTo: prevView!.bottomAnchor, constant: -lineWidth).isActive = true
            }
            NSLayoutConstraint.activate([
                labelView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                labelView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                labelView.heightAnchor.constraint(equalToConstant: height)
                ])
            
            prevView = labelView
        }
        
        prevView!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func getLabelString(_ index: Int) -> String {
        if index == 0 {
            return "Avg."
        }
        else if index == 1 {
            return "00-02"
        }
        else if index == 2 {
            return "02-06"
        }
        else if index < 6 {
            return "0\(index + 3)-0\(index + 4)"
        }
        else if index == 6 {
            return "09-10"
        }
        else if index == Constants.calendarTimeCount - 1 {
            return "23-00"
        }
        else {
            return "\(index + 3)-\(index + 4)"
        }
    }
    
    deinit {
        subviews.forEach{ $0.removeFromSuperview() }
    }

}
