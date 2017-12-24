//
//  UdacityDeleteSession.swift
//  OnTheMap
//
//  Created by User on 12/24/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

struct UdacityDeleteSession {
    let session: UdacitySession!
    
    init(dictionary: OTMDictionary) {
        session = UdacitySession(dictionary: dictionary["session"] as! OTMDictionary)
    }
    
}
