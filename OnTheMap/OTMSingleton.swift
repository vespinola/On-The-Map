//
//  OTMSession.swift
//  OnTheMap
//
//  Created by user on 12/30/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class OTMSingleton {
    
    var session: UdacityPostSession!
    var userData: OTMDictionary!
    var studentsInformation: [StudentInformation] = []
    
    class func shared() -> OTMSingleton {
        struct Singleton {
            static var shared = OTMSingleton()
        }
        return Singleton.shared
    }
    
    func clear() {
        session = nil
        userData = nil
        studentsInformation.removeAll()
    }
}
