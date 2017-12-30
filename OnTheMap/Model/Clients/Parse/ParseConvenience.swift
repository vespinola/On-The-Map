//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by User on 12/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

extension ParseHandler {
    func getStudentLocation(in viewController: CustomViewController, onCompletion: @escaping ([StudentInformation]) -> Void) {
        let parameters: OTMDictionary = [
            "limit" : 100,
            "order" : "-updatedAt"
        ]
        
        viewController.showActivityIndicatory()
        
        ParseHandler.sharedInstance().request(method: ParseHandler.Methods.StudentLocation, parameters: parameters, completionHandler: { data, error in
            
            viewController.hideActivityIndicator()
            
            guard error == nil else {
                Util.showAlert(for: (error?.localizedDescription ?? "empty error"), in: viewController)
                return
            }
            
            guard let array = data as? OTMDictionary else { return }
            
            let students = StudentInformation.studentLocationsFromResults(array["results"] as! [OTMDictionary])
            
            StudentInformation.students = students
            
            onCompletion(students)
        })
    }
    
    func getLoggedUserLocation(in viewController: CustomViewController, onCompletion: @escaping (StudentInformation?) -> Void) {
        
        let parameters: OTMDictionary = [
            "where" : "{\"uniqueKey\":\"\(UdacityHandler.sharedInstance().udacityUserData["key"]!)\"}",
            "limit" : 1
        ]
        
        viewController.showActivityIndicatory()
        
        ParseHandler.sharedInstance().request(method: ParseHandler.Methods.StudentLocation, parameters: parameters, completionHandler: { data, error in
            
            viewController.hideActivityIndicator()
            
            guard error == nil else {
                Util.showAlert(for: (error?.localizedDescription ?? "empty error"), in: viewController)
                return
            }
            
            guard let array = data as? OTMDictionary else { return }
            
            let students = StudentInformation.studentLocationsFromResults(array["results"] as! [OTMDictionary])
            
            onCompletion(students.first)
        })
    }
    
    func updateLoggedUserLocation(for studentLocation: StudentInformation, in viewController: CustomViewController, onCompletion: @escaping (StudentInformation) -> Void) {
        
        let parameters: OTMDictionary = [
            "uniqueKey" : studentLocation.uniqueKey!,
            "firstName" : studentLocation.firstName!,
            "lastName" : studentLocation.lastName!,
            "mapString" : studentLocation.mapString!,
            "mediaURL" : studentLocation.mediaURL!,
            "latitude" : studentLocation.latitude!,
            "longitude" : studentLocation.longitude!,
        ]
        
        viewController.showActivityIndicatory()
        
        ParseHandler.sharedInstance().request(verb: .put, method: ParseHandler.Methods.StudentLocation + "/\(studentLocation.objectId!)", jsonBody: parameters, completionHandler: { data, error in
            
            viewController.hideActivityIndicator()
            
            guard error == nil else {
                Util.showAlert(for: (error?.localizedDescription ?? "empty error"), in: viewController)
                return
            }
            
            guard let updateData = data as? OTMDictionary else { return }
            
            print(updateData)
            
            var updatedStudentLocation = studentLocation
            
            updatedStudentLocation.updatedAt = updateData["updatedAt"] as? String
            
            onCompletion(updatedStudentLocation)
        })
    }
    
    func postStudentLocation(with studentInformation: StudentInformation, in viewController: CustomViewController, onCompletion: @escaping (StudentInformation) -> Void) {
        
        
        let parameters: OTMDictionary = [
            "uniqueKey" : studentInformation.uniqueKey!,
            "firstName" : studentInformation.firstName!,
            "lastName" : studentInformation.lastName!,
            "mapString" : studentInformation.mapString!,
            "mediaURL" : studentInformation.mediaURL!,
            "latitude" : studentInformation.latitude!,
            "longitude" : studentInformation.longitude!,
        ]
        
        viewController.showActivityIndicatory()
        
        ParseHandler.sharedInstance().request(verb: .post, method: ParseHandler.Methods.StudentLocation, jsonBody: parameters, completionHandler: { data, error in
            
            viewController.hideActivityIndicator()
            
            guard error == nil else {
                Util.showAlert(for: (error?.localizedDescription ?? "empty error"), in: viewController)
                return
            }
            
            guard let createData = data as? OTMDictionary else { return }
            
            print(createData)
            
            var newStudentLocation = StudentInformation(dictionary: parameters)
            
            newStudentLocation.createdAt = createData["createdAt"] as? String
            newStudentLocation.objectId = createData["objectId"] as? String
            
            onCompletion(newStudentLocation)
        })
    }
    
}

