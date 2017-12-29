//
//  UdacitySession.swift
//  OnTheMap
//
//  Created by User on 12/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

struct UdacityPostSession {
    let account: UdacityAccount!
    let session: UdacitySession!
    
    init(dictionary: OTMDictionary) {
        account = UdacityAccount(dictionary: dictionary["account"] as! OTMDictionary)
        session = UdacitySession(dictionary: dictionary["session"] as! OTMDictionary)
    }
}

struct UdacityAccount {
    let registered: Bool!
    let key: String!
    
    init(dictionary: OTMDictionary) {
        registered = dictionary["registered"] as! Bool
        key = dictionary["key"] as! String
    }
}

struct UdacitySession {
    let id: String!
    let expiration: String!
    
    init(dictionary: OTMDictionary) {
        id = dictionary["id"] as! String
        expiration = dictionary["expiration"] as! String
    }
}
