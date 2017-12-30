//
//  UdacityHandler.swift
//  OnTheMap
//
//  Created by User on 12/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class UdacityHandler {
    var udacitySession: UdacityPostSession!
    var udacityUserData: OTMDictionary!
    
    var session = URLSession.shared
    
    func request(verb: HTTPMethod = .post, method: String, in viewController: UIViewController, parameters: OTMDictionary? = nil, jsonBody: OTMDictionary? = nil, completionHandler: @escaping( _ result: Any?, _ error: NSError?) -> Void) {
        
        let customViewController = viewController as? CustomViewController
        
        let request = NSMutableURLRequest(url: URLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = verb.method()
        
        
        if let body = jsonBody, verb == .put || verb == .post {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = Util.prepareForJsonBody(body)
            
        } else if verb == .delete {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        customViewController?.showActivityIndicatory()
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                customViewController?.hideActivityIndicator()
                
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "taskForMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
            
            customViewController?.hideActivityIndicator()
        }
        
        task.resume()
    }
    
    func clearCache() {
        udacitySession = nil
        udacityUserData = nil
    }
    
    class func sharedInstance() -> UdacityHandler {
        struct Singleton {
            static var sharedInstance = UdacityHandler()
        }
        return Singleton.sharedInstance
    }
    
    private func URLFromParameters(_ parameters: OTMDictionary? = nil, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityHandler.Constants.ApiScheme
        components.host = UdacityHandler.Constants.ApiHost
        components.path = UdacityHandler.Constants.ApiPath + (withPathExtension ?? "")
        
        if let parameters = parameters {
             components.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
}

extension UdacityHandler {
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Methods {
        static let Session = "/session"
        static let Users = "/users"
    }
}
