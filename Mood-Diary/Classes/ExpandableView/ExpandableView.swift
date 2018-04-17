//
//  DevelopmentView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/24/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

class ExpandableView: CustomView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerContainerView: UIView!
    
    var isAnimating: Bool = false
    var contentView: BaseContentView? {
        didSet {
            layoutView()
        }
    }
    var headerView: ExpandableHeader? {
        didSet {
            layoutHeader()
        }
    }
    var bottomConstraint: NSLayoutConstraint?
    
    var isExpand: Bool = false {
        didSet {
            if isAnimating {
                return
            }
            isAnimating = true
            UIView.animate(withDuration: 0.1, animations: {
                if self.isExpand {
                    if self.bottomConstraint != nil {
                        self.bottomConstraint?.isActive = false
                    }
                    self.bottomConstraint = self.contentView!.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
                    self.bottomConstraint?.isActive = true
                    self.contentView?.update()
                }
                else {
                    if self.bottomConstraint != nil {
                        self.bottomConstraint?.isActive = false
                    }
                }
                self.headerView?.animateArrow()
                self.layoutIfNeeded()
            }, completion: { (completed) in
                self.isAnimating = false
            })
        }
    }
    
    func layoutHeader() {
        headerContainerView.addSubview(headerView!)
        self.headerView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView!.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerView!.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            headerView!.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            headerView!.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor)
            ])
        
        headerView?.delegate = self
    }
    
    func layoutView() {
        containerView.addSubview(contentView!)
        self.contentView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView!.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentView!.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView!.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            ])
    }
}

extension ExpandableView: ExpandableHeaderDelegate {
    func toggleHeader() {
        isExpand = headerView!.header!.isExpanded
    }
}

