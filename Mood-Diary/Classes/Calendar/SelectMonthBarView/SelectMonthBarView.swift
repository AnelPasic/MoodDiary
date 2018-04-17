//
//  SelectMonthView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

protocol SelectMonthBarViewDelegate {
    func selectMonth()
    func nextWeek()
    func prevWeek()
    func today()
}

@IBDesignable
class SelectMonthBarView: CustomView {

    var delegate: SelectMonthBarViewDelegate?
    
    @IBOutlet weak var dateButton: UIButton!

    @IBAction func selectMonthAction(_ sender: Any) {
        if delegate != nil {
            delegate?.selectMonth()
        }
    }
    @IBAction func todayAction(_ sender: Any) {
        if delegate != nil {
            delegate?.today()
        }
    }
    @IBAction func prevWeekAction(_ sender: Any) {
        if delegate != nil {
            delegate?.prevWeek()
        }
    }
    @IBAction func nextWeekAction(_ sender: Any) {
        if delegate != nil {
            delegate?.nextWeek()
        }
    }
}
