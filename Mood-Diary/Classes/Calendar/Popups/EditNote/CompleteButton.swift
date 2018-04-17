//
//  CompleteButton.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/21/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

@objc protocol CompleteButtonDelegate {
    func selectedComplete(_ button: CompleteButton)
}

@IBDesignable
class CompleteButton: CircleButton {

    @IBOutlet weak
    var delegate: CompleteButtonDelegate!
    
//    var smileImageView: UIImageView? {
//        didSet {
//            guard let image = smileImageView?.image else {
//                return
//            }
//            
//            smileImageView?.image = image.withRenderingMode(.alwaysTemplate)
//            smileImageView?.tintColor = Constants.completeSmileColor
//        }
//    }
    
    @IBInspectable
    var number: Int {
        get {
            if let text = self.titleLabel?.text {
                return Int(text)!
            }
            else {
                return 1
            }
        }
        set {
            self.setTitle("\(newValue)", for: .normal)
        }
    }
    
    var isSelectedComplete: Bool = false {
        didSet {
            if isSelectedComplete {
                self.backgroundColor = Constants.appColor
//                smileImageView?.tintColor = Constants.completedColors[number - 1]
                self.setTitleColor(UIColor.white, for: .normal)
            }
            else {
                self.backgroundColor = .white
//                smileImageView?.tintColor = Constants.completeSmileColor
                self.setTitleColor(Constants.completeButtonTextColor, for: .normal)
            }
        }
    }

    override func layoutView() {
        super.layoutView()
        
        self.layer.borderColor = Constants.completeButtonBorderColor.cgColor
        self.layer.borderWidth = 1.0
        isSelectedComplete = false
        self.addTarget(self, action: #selector(selectComplete), for: .touchUpInside)
    }
    
    @objc func selectComplete() {
        if delegate != nil {
            delegate.selectedComplete(self)
        }
    }
}
