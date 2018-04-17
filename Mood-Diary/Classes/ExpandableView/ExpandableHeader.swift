//
//  ExpandableHeader.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/26/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
@objc protocol ExpandableHeaderDelegate {
    func toggleHeader()
}

class ExpandableHeader: UIView {
    
    let arrowIconSize: CGFloat = 24
    let titleFont = UIFont(name: "Avenir-Heavy", size: 16)
    let textColor = Constants.calendarTextColor
    
    @IBOutlet weak var delegate: ExpandableHeaderDelegate?
    
    let titleLabel = UILabel()
    let arrowIcon = UIImageView()
    
    var header: Header? {
        didSet {
            titleLabel.text = self.header?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        backgroundColor = .white
        titleLabel.textColor = textColor
        titleLabel.font = titleFont
        addSubview(titleLabel)
        
        arrowIcon.contentMode = .center
        arrowIcon.layer.borderColor = Constants.appColor.cgColor
        arrowIcon.layer.borderWidth = 1.0
        arrowIcon.image = #imageLiteral(resourceName: "icon_arrow").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        arrowIcon.tintColor = Constants.appColor
        arrowIcon.layer.cornerRadius = arrowIconSize / 2
        
        // Arrow icon
        addSubview(arrowIcon)
        
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        arrowIcon.widthAnchor.constraint(equalToConstant: arrowIconSize).isActive = true
        arrowIcon.heightAnchor.constraint(equalToConstant: arrowIconSize).isActive = true
        arrowIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrowIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        // bottom line
        let bottomLine = UIView(frame: .zero)
        bottomLine.backgroundColor = UIColor(colorWithHexValue: 0xABA8A8)
        addSubview(bottomLine)
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.7)
            ])
        
        //
        // Call tapHeader when tapping on this header
        //
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
    }
    //
    // Trigger toggle section when tapping on the header
    //
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        header?.isExpanded = !header!.isExpanded
        delegate?.toggleHeader()
    }
    
    func animateArrow() {
        if header!.isExpanded {
            arrowIcon.transform = CGAffineTransform.init(rotationAngle: .pi / 2)
        }
        else {
            arrowIcon.transform = CGAffineTransform.identity
        }
    }
}

