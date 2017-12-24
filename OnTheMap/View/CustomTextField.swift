//
//  CustomTextField.swift
//  OnTheMap
//
//  Created by administrator on 12/19/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    let textAlpha:CGFloat = 0.8
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15);
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        autocorrectionType = .no
        
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.cornerRadius = Constants.Metrics.cornerRadius
        layer.borderColor = UIColor.black.withAlphaComponent(textAlpha).cgColor
        tintColor = UIColor.black.withAlphaComponent(textAlpha)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
