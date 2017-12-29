//
//  HTTPHandler.swift
//  OnTheMap
//
//  Created by user on 12/29/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class HTTPHandler: NSObject {
    
    func verifyResponse(with data: Data?, error: Error?, and response: URLResponse?, completionHandler: @escaping( _ result: Any?, _ error: NSError?) -> Void) {
        
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandler(nil, NSError(domain: "taskForMethod", code: 1, userInfo: userInfo))
        }
        
        guard (error == nil) else {
            sendError("There was an error with your request: \(error!)")
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            sendError("Your request returned a status code other than 2xx!")
            return
        }
        
        guard data != nil else {
            sendError("No data was returned by the request!")
            return
        }
    }

}
