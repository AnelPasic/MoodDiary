//
//  UIColor+Extension.swift
//  Kebab
//
//  Created by Mobdev125 on 3/16/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

extension UIView {

    var hasSafeAreaInsets: Bool {
        guard #available (iOS 11, *) else { return false }
        return safeAreaInsets != .zero
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.1) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}
