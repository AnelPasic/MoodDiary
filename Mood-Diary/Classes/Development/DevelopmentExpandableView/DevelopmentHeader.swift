//
//  DailyTableViewHeaderCell.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/24/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class DevelopmentHeader: ExpandableHeader {

    let subTitleFont = UIFont(name: "Avenir-Medium", size: 13)
    let subTitleLabel = UILabel()
    
    override func layoutView() {
        super.layoutView()
        backgroundColor = .white
        
        subTitleLabel.textColor = textColor
        subTitleLabel.font = subTitleFont
        subTitleLabel.text = "Development"
        
        // Title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        // Subtitle label
        addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -16).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
}
