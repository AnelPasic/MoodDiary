//
//  UIColor+Extension.swift
//  Kebab
//
//  Created by Mobdev125 on 3/16/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000ff) / 255.0,
            alpha: alpha
        )
    }
    
    func convert(to color: UIColor, multiplier _multiplier: CGFloat) -> UIColor? {
        let multiplier = min(max(_multiplier, 0), 1)
        
        let components = cgColor.components ?? []
        let toComponents = color.cgColor.components ?? []
        
        if components.isEmpty || components.count < 3 || toComponents.isEmpty || toComponents.count < 3 {
            return nil
        }
        
        var results: [CGFloat] = []
        
        for index in 0...3 {
            let result = (toComponents[index] - components[index]) * abs(multiplier) + components[index]
            results.append(result)
        }
        
        return UIColor(red: results[0], green: results[1], blue: results[2], alpha: results[3])
    }
}
