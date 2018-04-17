//
//  String+Extension.swift
//  Kebab
//
//  Created by Mobdev125 on 3/20/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

extension String {
    func widthForLabel(_ font:UIFont) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 1
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.width
    }
}
