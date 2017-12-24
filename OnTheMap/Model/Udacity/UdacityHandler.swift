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
    
    var session = URLSession.shared
    
    func request(verb: HTTPMethod = .post, method: String, parameters: OTMDictionary? = nil, jsonBody: OTMDictionary? = nil, completionHandler: @escaping( _ result: Any?, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: URLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = verb.method()
        
        
        if let body = jsonBody, verb == .put || verb == .post {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = Util.prepareForJsonBody(body)
            
            //"{\"udacity\": {\"username\": \"vladimir.espinola@gmail.com\", \"password\": \"Informatica456*+\"}}".data(using: .utf8)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "taskForMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    func clearCache() {
        udacitySession = nil
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
            let newData = data.subdata(in: range) /* subset response data! */
            
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            
            print(parsedResult)
            
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
    }
}
