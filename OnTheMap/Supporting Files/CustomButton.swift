//
//  CustomButton.swift
//  OnTheMap
//
//  Created by User on 12/22/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = Constants.Metrics.cornerRadius
        backgroundColor = Constants.Colors.lightBlue
        tintColor = UIColor.white
    }
}
