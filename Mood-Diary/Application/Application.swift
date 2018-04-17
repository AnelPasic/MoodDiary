//
//  Application.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import Foundation
import Domain
import RealmPlatform

final class Application {
    static let shared = Application()
    
    private let realmUseCaseProvider: Domain.UseCaseProvider
    
    private init() {
        self.realmUseCaseProvider = RealmPlatform.UseCaseProvider()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let calendarUseCase = realmUseCaseProvider.makeCalendarUseCase()
        
        let calendarVC = storyboard.instantiateViewController(ofType: CalendarViewController.self)
        calendarVC.useCase = calendarUseCase
        calendarVC.tabBarItem = UITabBarItem(title: "Calendar",
                                                         image: #imageLiteral(resourceName: "icon_calendar"),
                                                         selectedImage: nil)
        
        DefaultCalendarNavigator.shared = DefaultCalendarNavigator(useCase: calendarUseCase,
                                                     viewController: calendarVC)
        
        let developmentVC = storyboard.instantiateViewController(ofType: DevelopmentViewController.self)
        developmentVC.useCase = realmUseCaseProvider.makeDevelopmentUseCase()
        developmentVC.tabBarItem = UITabBarItem(title: "Development", image: #imageLiteral(resourceName: "icon_development"), selectedImage: nil)
        
        let valueVC = storyboard.instantiateViewController(ofType: ValuesViewController.self)
        valueVC.tabBarItem = UITabBarItem(title: "Values", image: #imageLiteral(resourceName: "icon_values"), selectedImage: nil)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            calendarVC,
            developmentVC,
            valueVC
        ]
        
        tabBarController.tabBar.tintColor = Constants.appColor
        tabBarController.tabBar.unselectedItemTintColor = Constants.unselectedTabBarIconColor
        window.rootViewController = tabBarController
        
//        window.rootViewController = developmentVC
    }
}
