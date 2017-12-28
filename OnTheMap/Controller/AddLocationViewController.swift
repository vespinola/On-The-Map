//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by User on 12/24/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit
import MapKit

protocol AddLocationProtocol {
    func findLocation(with query: String, and link: String)
    func finish()
}

//from https://www.efectoapple.com/implementando-container-view-controller/

class AddLocationViewController: CustomViewController {
    @IBOutlet weak var firstContainer: UIView!
    
    private var activeViewController: UIViewController? {
        didSet {
            remove(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let findLocationViewController = storyboard.instantiateViewController(withIdentifier: "FindLocationViewControllerID") as? FindLocationViewController
        findLocationViewController?.delegate = self
        
        activeViewController = findLocationViewController
    }
    
    private func remove(inactiveViewController: UIViewController?) {
        guard let inactiveVC = inactiveViewController else { return }
        
        inactiveVC.willMove(toParentViewController: nil)
        inactiveVC.view.removeFromSuperview()
        inactiveVC.removeFromParentViewController()
    }
    
    private func updateActiveViewController() {
        guard let activeVC = activeViewController else { return }
        
        activeVC.view.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            activeVC.view.alpha = 1
        })
        
        addChildViewController(activeVC)
        activeVC.view.frame = firstContainer.bounds
        firstContainer.addSubview(activeVC.view)
        activeVC.didMove(toParentViewController: self)
    }

    @IBAction func cancelButtonOnTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddLocationViewController: AddLocationProtocol {
    func findLocation(with stringQuery: String, and link: String) {
        
        let performFinishLocationViewController: (StudentLocation) -> Void = { studentLocation in
            performUIUpdatesOnMain {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let finishLocationViewController = storyboard.instantiateViewController(withIdentifier: "FinishLocationViewControllerID") as? FinishLocationViewController
                finishLocationViewController?.delegate = self
                finishLocationViewController?.studentLocation = studentLocation
                
                self.activeViewController = finishLocationViewController
            }
        }
        
        
        searchLocation(with: stringQuery, onCompletion: { mapItem in
            
            ParseHandler.sharedInstance().getLoggedUserLocation(in: self, onCompletion: { studentLocation in
                
                if let studentLocation = studentLocation {
                    
                    var updateStudentLocation = studentLocation
                    
                    updateStudentLocation.mapString = stringQuery
                    updateStudentLocation.mediaURL = link
                    updateStudentLocation.latitude = mapItem.placemark.coordinate.latitude
                    updateStudentLocation.longitude = mapItem.placemark.coordinate.longitude
                    
                    
                    ParseHandler.sharedInstance().updateLoggedUserLocation(for: updateStudentLocation, in: self, onCompletion: { updatedStudentLocation in
                        performFinishLocationViewController(updatedStudentLocation)
                    })
                    
                } else {
                    
                    let userData = UdacityHandler.sharedInstance().udacityUserData!
                    
                    let studentData: OTMDictionary = [
                        "uniqueKey" : userData["key"]!,
                        "firstName" : userData["first_name"]!,
                        "lastName" : userData["last_name"]!,
                        "mapString" : stringQuery,
                        "mediaURL" : link,
                        "latitude" : mapItem.placemark.coordinate.latitude,
                        "longitude" : mapItem.placemark.coordinate.longitude
                    ]
                    
                    ParseHandler.sharedInstance().postStudentLocation(with: studentData, in: self, onCompletion: { studentLocation in
                        performFinishLocationViewController(studentLocation)
                    })
                }
            })
            
        })
        
    }
    
    func finish() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddLocationViewController {
    //MARK: Helpers
    
    func searchLocation(with string: String, onCompletion: @escaping (MKMapItem) -> Void) {
        let searchReq = MKLocalSearchRequest()
        searchReq.naturalLanguageQuery = string
//        searchReq.region = mapView.region
        
        let search = MKLocalSearch(request: searchReq)
        search.start(completionHandler: { response, error in
            guard let searchResponse = response, let firstPlace = searchResponse.mapItems.first, error == nil else {
                return
            }
            
            onCompletion(firstPlace)
        })
        
    }
}
