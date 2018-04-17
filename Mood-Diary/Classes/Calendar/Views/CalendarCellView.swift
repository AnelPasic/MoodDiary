//
//  LabelView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class CalendarCellView: UIView {
    var borderColor: UIColor = Constants.calendarLineColor {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var borderWidth: CGFloat = Constants.calendarLineWidth {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
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
        backgroundColor = UIColor.white
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
}
