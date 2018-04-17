//
//  ValuesHeader.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/26/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class ValuesHeader: ExpandableHeader {
    
    let headerIconSize: CGFloat = 40
    let titleMargin: CGFloat = 16.0
    let headerIcon = UIImageView()
    
    var headerImage: UIImage? {
        didSet {
            headerIcon.image = headerImage?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var value: Value? {
        didSet {
            header = value
            headerImage = value!.image
        }
    }
    
    override func layoutView() {
        super.layoutView()
        backgroundColor = .white
        
        headerIcon.contentMode = .scaleAspectFit
        headerIcon.tintColor = Constants.appColor
        
        // Arrow icon
        addSubview(headerIcon)
        
        headerIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: titleMargin),
            headerIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            headerIcon.widthAnchor.constraint(equalToConstant: headerIconSize),
            headerIcon.heightAnchor.constraint(equalToConstant: headerIconSize),
            headerIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: titleMargin),
            headerIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -titleMargin)
            ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerIcon.trailingAnchor, constant: titleMargin),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//            titleLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -titleMargin)
            ])
    }
}

