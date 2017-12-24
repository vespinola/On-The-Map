//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by User on 12/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

extension UdacityHandler {
    func postSession(with parameters: OTMDictionary, in viewController: UIViewController, onCompletion: @escaping (UdacityPostSession) -> Void) {
        
        let parametersWrapper = [
            "udacity" : parameters
        ]
        
        let _ = UdacityHandler.sharedInstance().request(method: UdacityHandler.Methods.Session, jsonBody: parametersWrapper, completionHandler: { data, error in
            guard error == nil else {
                Util.showAlert(for: (error?.description ?? "empty error"), in: viewController)
                return
            }
            
            guard let dictionary = data as? OTMDictionary else { return }
            
            let session = UdacityPostSession(dictionary: dictionary)
            
            onCompletion(session)
        })
    }
    
}
