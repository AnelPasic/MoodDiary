//
//  Constants.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation
import UIKit

class Constants {

    static let shared = Constants()
    
    static let appColor = UIColor(colorWithHexValue: 0x00bcd4)
    static let pastColor = UIColor(colorWithHexValue: 0x2bc7db)
    static let futureColor = UIColor(colorWithHexValue: 0xffae37)
    
    static let calendarTextFont = UIFont(name: "Avenir-Book", size: 12.0)
    static let calendarTextColor = UIColor(colorWithHexValue: 0x616161)
    static let calendarLineColor = Constants.appColor
    static let calendarLineWidth: CGFloat = 1.0
    static let calendarTimeCount = 21
    
    static let completedColors = [UIColor(colorWithHexValue: 0xf44336),
                                  UIColor(colorWithHexValue: 0xff9800),
                                  UIColor(colorWithHexValue: 0x616161),
                                  UIColor(colorWithHexValue: 0x00bcd4),
                                  UIColor(colorWithHexValue: 0x4caf50)]
    
    static let completeButtonBorderColor = UIColor(colorWithHexValue: 0xa3a3a3)
    static let completeButtonTextColor = UIColor(colorWithHexValue: 0x424242)
    static let completeSmileColor = UIColor(colorWithHexValue: 0x616161)
    
    static let unselectedTabBarIconColor = UIColor(colorWithHexValue: 0x444444)
    
    static let yearRange = 20
    static let countOfYearLine = 4
    
    static let graphContentViewHeight: CGFloat = 300
    static let valueContentTextColor = UIColor(colorWithHexValue: 0x444444)
    static let valueContentBorderColor = UIColor(colorWithHexValue: 0xe0e0e0)
    
    // Notifications
    static let ClickedCalendarCellNotification = Notification.Name("ClickedCalendarCellNotification")
    
    static let cornerRadius: CGFloat = 4.0
    
    static let calendarMargin: CGFloat = 16.0
    
    var calendarCellWidth: CGFloat {
        let width = (UIScreen.main.bounds.width - Constants.calendarMargin * 2) / 8
        guard #available (iOS 11, *), let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets else { return width }
        return width - safeAreaInsets.left - safeAreaInsets.right
    }
    
    var calendarCellHeight: CGFloat = 36.0
    
    static let developements = [Header("Daily"), Header("Weekly"), Header("All")]
    static let values = [Value(#imageLiteral(resourceName: "icon_relations"), "Relationships", .relations),
                         Value(#imageLiteral(resourceName: "icon_work_education"), "Work / Education", .workEducation),
                         Value(#imageLiteral(resourceName: "icon_freetime"), "Free time", .freeTime),
                         Value(#imageLiteral(resourceName: "icon_personal"), "Personal growth / Health", .personalGrowthHealth),
                         Value(#imageLiteral(resourceName: "icon_info"), "Info", .info)]
    
    static let infoString: String = """
                    This app stores information locally on your phone. This means that the information you put in will be erased if you delete the app. It also means that only the operator of the app will have access to user information
                    For more information visit:
                    https://getstartedwithselfhelp.com (english)
                    https://psykologiskveiledning.com (norwegian)
                    """
}

class Header {
    var title: String = ""
    var isExpanded: Bool = false
    
    init(_ title: String) {
        self.title = title
    }
}

enum ValueType: String {
    case relations = "Relations"
    case workEducation = "Work / Education"
    case freeTime = "freeTime"
    case personalGrowthHealth = "Personal growth / Health"
    case info = "Made by Magnus Nordmo"
}
class Value: Header {
    var image: UIImage?
    var content: String {
        get {
            return UserDefaults.standard.string(forKey: type.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: type.rawValue)
        }
    }
    var type: ValueType = .relations
    
    init(_ image: UIImage, _ title: String, _ type: ValueType) {
        super.init(title)
        self.type = type
        self.image = image
    }
}
