//
//  RoundedImageView.swift
//  Kebab
//
//  Created by Mobdev125 on 3/19/18.
//  Copyright © 2018 Mobdev125. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    
    @IBInspectable
    open var cornerRadius: CGFloat = Constants.cornerRadius {
        didSet {
            self.layoutView()
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
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
}

