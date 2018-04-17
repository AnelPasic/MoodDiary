//
//  SecondViewController.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Domain

class DevelopmentViewController: UIViewController {

    var useCase: DevelopmentUseCase!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topLineView: UIView!
    
    var headers = Constants.developements
    
    deinit {
        headers.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
    }

    func layoutView() {
        let date = Date.today()
        let year = date.getYear
        let month = date.getMonth
        let week = date.getWeekOfYear
        
        let dailyView = addExpandableView(DailyDevelopmentView(year: year, month: month, week: week, useCase: useCase), headers[0], topView: topLineView)
        let weeklyView = addExpandableView(WeeklyDevelopmentView(year: year, week: week, useCase: useCase), headers[1], topView: dailyView)
        let allView = addExpandableView(AllDevelopmentView(year: year, useCase: useCase), headers[2], topView: weeklyView)
        
        allView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    func addExpandableView(_ contentView: BaseContentView, _ header: Header, topView: UIView?) -> UIView {
        let expandableView = ExpandableView(frame: .zero)
        containerView.addSubview(expandableView)
        
        let headerView = DevelopmentHeader(frame: .zero)
        headerView.header = header
        
        expandableView.contentView = contentView
        expandableView.headerView = headerView
        
        expandableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            expandableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
        
        if topView != nil {
            expandableView.topAnchor.constraint(equalTo: topView!.bottomAnchor).isActive = true
        }
        else {
            expandableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        }
        
        expandableView.contentView!.heightAnchor.constraint(equalToConstant: Constants.graphContentViewHeight).isActive = true
        
        return expandableView
    }
}

