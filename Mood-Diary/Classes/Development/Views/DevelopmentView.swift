//
//  DevelopmentView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/25/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class DevelopmentView: CustomView {

    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var gestureView: UIView!

    static func layoutDevelopment(_ view: UIView) -> DevelopmentView {
        let developmentView = DevelopmentView(frame: .zero)
        view.addSubview(developmentView)
        
        developmentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            developmentView.topAnchor.constraint(equalTo: view.topAnchor),
            developmentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            developmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            developmentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        return developmentView
    }
}
