//
//  CompleteLeftValueFormatter.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/24/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation
import Charts

public class CompleteLeftValueFormatter: NSObject, IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))"
    }
}

