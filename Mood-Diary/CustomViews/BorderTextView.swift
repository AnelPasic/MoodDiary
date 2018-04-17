//
//  BorderTextView.swift
//  Mood-Diary
//
//  Created by Mobdev125 on 3/22/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

@IBDesignable
class BorderTextView: UITextView {
    
    @IBInspectable
    open var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layoutView()
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor = Constants.completeButtonBorderColor {
        didSet {
            self.layoutView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutView()
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        clipsToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
}
