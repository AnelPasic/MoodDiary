//
//  CustomView.swift
//  Tryk og glad
//
//  Created by Mobdev125 on 12/22/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    var view: UIView?
    
    // Loads instance from nib with the same name.
    func loadNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        if view != nil {
            return
        }
        
        guard let view = loadNib() else {
            return
        }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)
        
        self.view = view
        
        prepare()
    }
    
    func prepare() {
        
    }
}


