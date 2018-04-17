//
//  ValuesViewController.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class ValuesViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topLineView: UIView!
    
    var values = Constants.values
    
    deinit {
        values.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
    }
    
    func layoutView() {
        var prevView: UIView = topLineView
        for i in 0..<(values.count - 1) {
            prevView = addExpandableView(values[i], topView: prevView, isEditable: true)
        }
        prevView = addExpandableView(values.last!, topView: prevView, isEditable: false)
        prevView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    func addExpandableView(_ value: Value, topView: UIView?, isEditable: Bool = true) -> UIView {
        let expandableView = ExpandableView(frame: .zero)
        containerView.addSubview(expandableView)
        
        let headerView = ValuesHeader(frame: .zero)
        headerView.value = value
        
        let contentView = ValuesContentView(isEditable)
        contentView.value = value
        contentView.textColor = Constants.calendarTextColor
        
        expandableView.headerView = headerView
        expandableView.contentView = contentView
        
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
        
        return expandableView
    }

}
