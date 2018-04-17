//
//  AllDevelopmentView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/26/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Domain

class AllSelect {
    private var allView: AllDevelopmentView!
    public var year = Date().getYear {
        didSet {
            DispatchQueue.main.async {
                self.allView.update()
            }
        }
    }
    
    init(with allView: AllDevelopmentView) {
        self.allView = allView
    }
}

class AllDevelopmentView: BaseContentView {
    
    
    var developmentView: DevelopmentView!
    var allCalendarPopupView: SelectYearPopupView!
    var allChartView: AllGraphView!
    var allCalendarNavigationView: AllCalendarNavigationView!
    var allSelect: AllSelect!
    
    init(year: Int, useCase: DevelopmentUseCase) {
        super.init(frame: .zero)
        allSelect = AllSelect(with: self)
        
        layoutDevelopment()
        layoutCalendar(year: year)
        layoutGraph(year: year, useCase: useCase)
        layoutCalendarPopup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutDevelopment() {
        developmentView = DevelopmentView.layoutDevelopment(self)
    }
    
    func layoutCalendar(year: Int) {
        allCalendarNavigationView = AllCalendarNavigationView(frame: .zero)
        allCalendarNavigationView.delegate = self
        developmentView.calendarContainerView.addSubview(allCalendarNavigationView)
        
        allCalendarNavigationView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            allCalendarNavigationView.topAnchor.constraint(equalTo: developmentView.calendarContainerView.topAnchor),
            allCalendarNavigationView.leadingAnchor.constraint(equalTo: developmentView.calendarContainerView.leadingAnchor),
            allCalendarNavigationView.trailingAnchor.constraint(equalTo: developmentView.calendarContainerView.trailingAnchor),
            allCalendarNavigationView.bottomAnchor.constraint(equalTo: developmentView.calendarContainerView.bottomAnchor),
            allCalendarNavigationView.heightAnchor.constraint(equalToConstant: 50.0)
            ])
        
        allCalendarNavigationView.updateYear(allSelect.year)
    }
    func layoutGraph(year: Int, useCase: DevelopmentUseCase) {
        allChartView = AllGraphView(frame: .zero)
        allChartView.useCase = useCase
        developmentView.chartContainerView.addSubview(allChartView)
        
        allChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            allChartView.topAnchor.constraint(equalTo: developmentView.chartContainerView.topAnchor),
            allChartView.bottomAnchor.constraint(equalTo: developmentView.chartContainerView.bottomAnchor),
            allChartView.leadingAnchor.constraint(equalTo: developmentView.chartContainerView.leadingAnchor),
            allChartView.trailingAnchor.constraint(equalTo: developmentView.chartContainerView.trailingAnchor),
            allChartView.widthAnchor.constraint(equalToConstant: 1200)
            ])
        
//        developmentView.gestureView.onSwipe(to: .right) { (gestureRecognizer) in
//            self.prevYear()
//        }
//        developmentView.gestureView.onSwipe(to: .left) { (gestureRecognizer) in
//            self.nextYear()
//        }
        
        developmentView.gestureView.isHidden = true
        
        allChartView.updateGraph(allSelect.year)
    }
    
    func layoutCalendarPopup() {
        allCalendarPopupView = SelectYearPopupView(frame: bounds)
        allCalendarPopupView.isHidden = true
        
        addSubview(allCalendarPopupView)
        
        allCalendarPopupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            allCalendarPopupView.topAnchor.constraint(equalTo: developmentView.topAnchor, constant: 50),
            allCalendarPopupView.bottomAnchor.constraint(equalTo: developmentView.bottomAnchor),
            allCalendarPopupView.leadingAnchor.constraint(equalTo: developmentView.leadingAnchor),
            allCalendarPopupView.trailingAnchor.constraint(equalTo: developmentView.trailingAnchor)
            ])
        
        allCalendarPopupView.allSelect = self.allSelect
    }
    
    override func update() {
        let year = allSelect.year
        allChartView.updateGraph(year)
        allCalendarNavigationView.updateYear(year)
        allCalendarPopupView.isShow = false
    }
}

extension AllDevelopmentView: AllCalendarNavigationViewDelegate {
    func current() {
        allSelect.year = Date.today().getYear
    }
    
    func prevYear() {
        if allCalendarPopupView.isShow {
            return
        }
        
        allSelect.year -= 1
    }
    
    func nextYear() {
        if allCalendarPopupView.isShow {
            return
        }
        allSelect.year += 1
    }
    
    func showCalendar() {
        self.allCalendarPopupView.isShow = !self.allCalendarPopupView.isShow
    }
}
