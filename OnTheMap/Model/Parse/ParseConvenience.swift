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
        
        ParseHandler.sharedInstance().request(method: ParseHandler.Methods.StudentLocation, in: viewController, parameters: parameters, completionHandler: { data, error in
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
    
    func getLoggedUserLocation(in viewController: UIViewController, onCompletion: @escaping (StudentLocation?) -> Void) {
        
        let parameters: OTMDictionary = [
            "where" : "{\"uniqueKey\":\"\(UdacityHandler.sharedInstance().udacityUserData["key"]!)\"}",
            "limit" : 1
        ]
        
        ParseHandler.sharedInstance().request(method: ParseHandler.Methods.StudentLocation, in: viewController, parameters: parameters, completionHandler: { data, error in
            guard error == nil else {
                Util.showAlert(for: (error?.description ?? "empty error"), in: viewController)
                return
            }
            
            guard let array = data as? OTMDictionary else { return }
            
            let students = StudentLocation.studentLocationsFromResults(array["results"] as! [OTMDictionary])
            
            onCompletion(students.first)
        })
    }
    
    func updateLoggedUserLocation(for studentLocation: StudentLocation, in viewController: UIViewController, onCompletion: @escaping (StudentLocation) -> Void) {
        
        let parameters: OTMDictionary = [
            "uniqueKey" : studentLocation.uniqueKey!,
            "firstName" : studentLocation.firstName!,
            "lastName" : studentLocation.lastName!,
            "mapString" : studentLocation.mapString!,
            "mediaURL" : studentLocation.mediaURL!,
            "latitude" : studentLocation.latitude!,
            "longitude" : studentLocation.longitude!,
        ]
        
        ParseHandler.sharedInstance().request(verb: .put, method: ParseHandler.Methods.StudentLocation + "/\(studentLocation.objectId!)", in: viewController, jsonBody: parameters, completionHandler: { data, error in
            guard error == nil else {
                Util.showAlert(for: (error?.description ?? "empty error"), in: viewController)
                return
            }
            
            guard let updateData = data as? OTMDictionary else { return }
            
            var updatedStudentLocation = studentLocation
            
            updatedStudentLocation.updatedAt = updateData["updatedAt"] as? String
            
            onCompletion(updatedStudentLocation)
        })
    }
    
    func postStudentLocation(with parameters: OTMDictionary, in viewController: UIViewController, onCompletion: @escaping (StudentLocation) -> Void) {
        
        ParseHandler.sharedInstance().request(verb: .post, method: ParseHandler.Methods.StudentLocation, jsonBody: parameters, completionHandler: { data, error in
            guard error == nil else {
                Util.showAlert(for: (error?.description ?? "empty error"), in: viewController)
                return
            }
            
            guard let createData = data as? OTMDictionary else { return }
            
            var newStudentLocation = StudentLocation(dictionary: parameters)
            
            newStudentLocation.createdAt = createData["createdAt"] as? String
            newStudentLocation.objectId = createData["objectId"] as? String
            
            onCompletion(newStudentLocation)
        })
    }
    
}

