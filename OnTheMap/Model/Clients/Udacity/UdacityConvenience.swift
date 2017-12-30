//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by User on 12/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

extension UdacityHandler {
    func postSession(with parameters: OTMDictionary, in viewController: CustomViewController, onCompletion: @escaping (UdacityPostSession) -> Void) {
        
        let parametersWrapper = [
            "udacity" : parameters
        ]
        
        viewController.showActivityIndicatory()
        
        UdacityHandler.sharedInstance().request(method: UdacityHandler.Methods.Session, jsonBody: parametersWrapper, completionHandler: { data, error in
            
            viewController.hideActivityIndicator()
            
            guard error == nil else {
                Util.showAlert(for: (error?.localizedDescription ?? "empty error"), in: viewController)
                return
            }
            
            guard let dictionary = data as? OTMDictionary else { return }
            
            if let error = dictionary["error"] as? String {
                Util.showAlert(for: error, in: viewController)
            } else {
                let session = UdacityPostSession(dictionary: dictionary)
                onCompletion(session)
            }
            
        })
    }
    
    func deleteSession(in viewController: CustomViewController, onCompletion: @escaping (UdacityDeleteSession) -> Void) {
        
        viewController.showActivityIndicatory()
        
        UdacityHandler.sharedInstance().request(verb: .delete, method: UdacityHandler.Methods.Session, completionHandler: { data, error in
            
            viewController.hideActivityIndicator()
            
            guard error == nil else {
                Util.showAlert(for: (error?.localizedDescription ?? "empty error"), in: viewController)
                return
            }
            
            guard let dictionary = data as? OTMDictionary else { return }
            
            let session = UdacityDeleteSession(dictionary: dictionary)
            
            onCompletion(session)
        })
    }
    
    func getUserData(in viewController: CustomViewController, onCompletion: @escaping (OTMDictionary) -> Void) {
        let sessionKey = UdacityHandler.sharedInstance().udacitySession.account.key!
        
        viewController.showActivityIndicatory()
        
        UdacityHandler.sharedInstance().request(verb: .get, method: UdacityHandler.Methods.Users + "/\(sessionKey)", completionHandler: { data, error in
            
            viewController.hideActivityIndicator()
            
            guard error == nil else {
                Util.showAlert(for: (error?.localizedDescription ?? "empty error"), in: viewController)
                return
            }
            
            guard let dictionary = data as? OTMDictionary else { return }
            
            onCompletion(dictionary["user"] as! OTMDictionary)
        
        })
    }    
}
