//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by User on 12/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

extension ParseHandler {
    func getStudentLocation(in viewController: UIViewController, onCompletion: @escaping ([StudentLocation]) -> Void) {
        let parameters: OTMDictionary = [
            "limit" : 100
        ]
        
        ParseHandler.sharedInstance().request(method: ParseHandler.Methods.StudentLocation, parameters: parameters, completionHandler: { data, error in
            guard error == nil else {
                Util.showAlert(for: (error?.description ?? "empty error"), in: viewController)
                return
            }
            
            guard let array = data as? OTMDictionary else { return }
            
            let students = StudentLocation.studentLocationsFromResults(array["results"] as! [OTMDictionary])
            
            ParseHandler.sharedInstance().studentsLocation = students
            
            onCompletion(students)
        })
    }
    
    func getLoggedUserLocation(in viewController: UIViewController, onCompletion: @escaping (StudentLocation) -> Void) {
        
        let uniqueKeyParameter: OTMDictionary = [
            "uniqueKey" : UdacityHandler.sharedInstance().udacityUserData["key"]!
        ]
        
        let parameters: OTMDictionary = [
            "where" : uniqueKeyParameter,
            "limit" : 1
        ]
        
        ParseHandler.sharedInstance().request(method: ParseHandler.Methods.StudentLocation, parameters: parameters, completionHandler: { data, error in
            guard error == nil else {
                Util.showAlert(for: (error?.description ?? "empty error"), in: viewController)
                return
            }
            
            guard let array = data as? OTMDictionary else { return }
            
            let students = StudentLocation.studentLocationsFromResults(array["results"] as! [OTMDictionary])
            
            onCompletion(students.first!)
        })
    }
    
}

