//
//  Calendar+Extension.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
    
    func getWeekOfMonth(_ date: Date) -> Int {
        return component(.weekOfMonth, from: date)
    }
}
