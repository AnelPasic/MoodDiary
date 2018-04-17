//
//  YearCollectionView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/26/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class YearRangeView: UIView {

    var startYear: Int = 0 {
        didSet {
            update()
        }
    }
    var yearButtonViews = [YearCellButtonView]()
    
    init(_ startYear: Int, _ allSelect: AllSelect) {
        super.init(frame: .zero)
        self.startYear = startYear
        layoutView(allSelect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutView(_ allSelect: AllSelect) {
        var prevView: UIView? = nil
        for i in 0..<Int(Constants.yearRange / Constants.countOfYearLine) {
            for j in 0..<Constants.countOfYearLine {
                let yearButton = YearCellButtonView.init(startYear + i * 4 + j, allSelect)
                addSubview(yearButton)
                
                yearButton.translatesAutoresizingMaskIntoConstraints = false
                
                if i == 0 && j == 0 {
                    yearButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                    yearButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                }
                else if j == 0 {
                    yearButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                    yearButton.topAnchor.constraint(equalTo: prevView!.bottomAnchor).isActive = true
                }
                else {
                    yearButton.leadingAnchor.constraint(equalTo: prevView!.trailingAnchor).isActive = true
                    yearButton.topAnchor.constraint(equalTo: prevView!.topAnchor).isActive = true
                }
                
                yearButtonViews.append(yearButton)
                prevView = yearButton
            }
            prevView!.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
        
        prevView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        yearButtonViews.forEach {
            if $0 != prevView {
                $0.widthAnchor.constraint(equalTo: prevView!.widthAnchor).isActive = true
                $0.heightAnchor.constraint(equalTo: prevView!.heightAnchor).isActive = true
            }
        }
    }

    fileprivate func update() {
        for i in 0..<yearButtonViews.count {
            yearButtonViews[i].currentYear = startYear + i
        }
    }
}
