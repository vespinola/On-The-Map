//
//  Constants.swift
//  OnTheMap
//
//  Created by administrator on 12/19/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
    struct Segues {
        static let home = "homeSegue"
        static let addLocationFromMap = "addLocationStep1FromFirstTab"
        static let addLocationFromList = "addLocationStep1FromSecondTab"
    }
    
    struct Metrics {
        static let cornerRadius: CGFloat = 7
    }
    
    struct Colors {
        static let lightBlue = UIColor(netHex: 0x02B3E4) // I am not good naming colors :(
    }
    
    struct Fonts {
        static let standard = UIFont.boldSystemFont(ofSize: 15)
    }

}
