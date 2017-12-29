//
//  ParseHandler.swift
//  OnTheMap
//
//  Created by User on 12/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class ParseHandler: HTTPHandler {
    // shared session
    var studentsLocation: [StudentInformation] = []
    
    var session = URLSession.shared
    
    func request(verb: HTTPMethod = .get, method: String, in viewController: UIViewController? = nil, parameters: OTMDictionary? = nil, jsonBody: OTMDictionary? = nil, completionHandler: @escaping( _ result: Any?, _ error: NSError?) -> Void) {
        
        let customViewController = viewController as? CustomViewController
    
        let request = NSMutableURLRequest(url: URLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = verb.method()
        
        request.addValue(ParseHandler.Constants.ApiKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseHandler.Constants.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        if let jsonBody = jsonBody {
            request.httpBody = Util.prepareForJsonBody(jsonBody)
        }
        
        if verb == .put || verb == .post {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        customViewController?.showActivityIndicatory()
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            self.verifyResponse(with: data, error: error, and: response, completionHandler: completionHandler)
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandler)
            
            customViewController?.hideActivityIndicator()
            
        }
        
        task.resume()        
    }
    
    func clearCache() {
        studentsLocation = []
    }
    
    class func sharedInstance() -> ParseHandler {
        struct Singleton {
            static var sharedInstance = ParseHandler()
        }
        return Singleton.sharedInstance
    }
    
    private func URLFromParameters(_ parameters: OTMDictionary?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseHandler.Constants.ApiScheme
        components.host = ParseHandler.Constants.ApiHost
        components.path = ParseHandler.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
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
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
}

extension ParseHandler {
    struct Constants {
        // MARK: API Key
        static let ApiKey = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: Rest API Key
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
}
