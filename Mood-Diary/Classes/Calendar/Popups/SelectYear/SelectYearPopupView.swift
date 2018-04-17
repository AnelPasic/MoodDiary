//
//  SelectYearPopupView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/26/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit
import Sensitive

class SelectYearPopupView: CustomView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var yeatRange: UIButton!
    
    var allSelect: AllSelect? {
        didSet {
            layoutView()
        }
    }
    var isShow: Bool = false {
        didSet {
            updateLayout()
            UIView.animate(withDuration: 1.0, animations: {
                self.isHidden = !self.isShow
                self.layoutIfNeeded()
            }) { (completed) in
            }
        }
    }
    
    var currentYearView: YearRangeView?
    var prevYearView: YearRangeView?
    var nextYearView: YearRangeView?
    
    var isTransforming = false
    
    deinit {
        currentYearView = nil
        prevYearView = nil
        nextYearView = nil
        containerView.subviews.forEach{ $0.removeFromSuperview() }
    }
    
    override func prepare() {
        super.prepare()
        guard let contentView = self.view else {
            return
        }
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 5
        
        backgroundColor = .clear
    }
    
    @IBAction func tapHandler(_ sender: Any) {
        self.isShow = false
    }
    
    func updateLayout() {
        let startYear = getStartYear()
        currentYearView?.startYear = startYear
        prevYearView?.startYear = startYear - Constants.yearRange
        nextYearView?.startYear = startYear + Constants.yearRange
        
        currentYearView?.transform = CGAffineTransform.identity
        prevYearView?.transform = CGAffineTransform(translationX: -currentYearView!.frame.width, y: 0)
        nextYearView?.transform = CGAffineTransform(translationX: currentYearView!.frame.width, y: 0)
        updateYearRange(startYear)
        self.layoutIfNeeded()
    }
    
    func updateYearRange(_ startYear: Int) {
        yeatRange.setTitle("\(startYear) - \(startYear + Constants.yearRange)", for: .normal)
    }
    func getStartYear() -> Int {
        return Int((allSelect!.year - 2000) / Constants.yearRange) * Constants.yearRange + 2000
    }
    func layoutView() {
        let startYear = getStartYear()
        currentYearView = addYearView(startYear)
        prevYearView = addYearView(startYear - Constants.yearRange)
        nextYearView = addYearView(startYear + Constants.yearRange)
        
        containerView.onSwipe(to: .left) { (gesture) in
            self.next()
        }
        containerView.onSwipe(to: .right) { (gesture) in
            self.prev()
        }
    }
    
    func addYearView(_ startYear: Int) -> YearRangeView{
        let yearView = YearRangeView.init(startYear, allSelect!)
        containerView.addSubview(yearView)
        
        yearView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearView.topAnchor.constraint(equalTo: containerView.topAnchor),
            yearView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            yearView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            yearView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        return yearView
    }
    @IBAction func prevAction(_ sender: Any) {
        prev()
    }
    @IBAction func nextAction(_ sender: Any) {
        next()
    }
    
    func next() {
        transformYearViews(false)
    }
    func prev() {
        transformYearViews(true)
    }
    
    func updateYearView(isPrev: Bool) {
        if isPrev {
            prevYearView?.startYear = currentYearView!.startYear - Constants.yearRange
        }
        else {
            nextYearView?.startYear = currentYearView!.startYear + Constants.yearRange
        }
        updateYearRange(currentYearView!.startYear)
    }
    
    func transformYearViews(_ isPrev: Bool, _ ratio: Double = 1.0) {
        if isTransforming {
            return
        }
        isTransforming = true
        let width = currentYearView!.superview!.frame.width * (isPrev ? 1 : -1)
        UIView.animate(withDuration: 0.3 * ratio, animations: { [weak self] in
            self?.currentYearView?.transform = CGAffineTransform(translationX: width, y: 0)
            if isPrev {
                self?.prevYearView?.transform = CGAffineTransform.identity
            }
            else {
                self?.nextYearView?.transform = CGAffineTransform.identity
            }
            self?.layoutIfNeeded()
        }) { [weak self] (completed) in
            if isPrev {
                let yearView = self?.nextYearView
                self?.nextYearView = self?.currentYearView
                self?.currentYearView = self?.prevYearView
                self?.prevYearView = yearView
                self?.prevYearView?.transform = CGAffineTransform(translationX: -width, y: 0)
            }
            else {
                let yearView = self?.prevYearView
                self?.prevYearView = self?.currentYearView
                self?.currentYearView = self?.nextYearView
                self?.nextYearView = yearView
                self?.nextYearView?.transform = CGAffineTransform(translationX: -width, y: 0)
            }
            self?.currentYearView?.superview?.bringSubview(toFront: (self?.currentYearView)!)
            self?.updateYearView(isPrev: isPrev)
            self?.layoutIfNeeded()
            self?.isTransforming = false
        }
    }
}
