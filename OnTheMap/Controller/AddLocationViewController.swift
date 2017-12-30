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
    func finish(for studentInformation: StudentInformation, action: AddLocationAction)
}

enum AddLocationAction {
    case create, update
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
    
    //used on FindViewController
    func findLocation(with stringQuery: String, and link: String) {
        
        let performFinishLocationViewController: (StudentInformation, AddLocationAction) -> Void = { studentLocation, action in
            performUIUpdatesOnMain {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let finishLocationViewController = storyboard.instantiateViewController(withIdentifier: "FinishLocationViewControllerID") as? FinishLocationViewController
                finishLocationViewController?.delegate = self
                finishLocationViewController?.studentLocation = studentLocation
                finishLocationViewController?.addLocationAction = action
                
                self.activeViewController = finishLocationViewController
            }
        }
        
        self.searchLocation(with: stringQuery, onCompletion: { mapItem in
            ParseHandler.sharedInstance().getLoggedUserLocation(in: self, onCompletion: { studentLocation in
                if var updateStudentLocation = studentLocation {
                    
                    updateStudentLocation.mapString = stringQuery
                    updateStudentLocation.mediaURL = link
                    updateStudentLocation.latitude = mapItem.placemark.coordinate.latitude
                    updateStudentLocation.longitude = mapItem.placemark.coordinate.longitude
                    
                    performFinishLocationViewController(updateStudentLocation, .update)

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
                    
                    let newStudentLocaiton = StudentInformation(dictionary: studentData)
                    
                    performFinishLocationViewController(newStudentLocaiton, .create)
                    
                }
            })
        })
    }
    
    //used on FinishViewController
    func finish(for studentInformation: StudentInformation, action: AddLocationAction) {
        switch action {
        case .create:
            ParseHandler.sharedInstance().postStudentLocation(with: studentInformation, in: self, onCompletion: { studentLocation in
                self.dismiss(animated: true, completion: nil)
            })
        case .update:
            ParseHandler.sharedInstance().updateLoggedUserLocation(for: studentInformation, in: self, onCompletion: { updatedStudentLocation in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}

extension AddLocationViewController {
    //MARK: Helpers
    
    func searchLocation(with string: String, onCompletion: @escaping (MKMapItem) -> Void) {
        let searchReq = MKLocalSearchRequest()
        searchReq.naturalLanguageQuery = string
        
        let search = MKLocalSearch(request: searchReq)
        
        showActivityIndicatory()
        
        search.start(completionHandler: { response, error in
            self.hideActivityIndicator()
            
            guard let searchResponse = response, let firstPlace = searchResponse.mapItems.first, error == nil else {
                Util.showAlert(for: "Cannot get a location for \(string)", in: self)
                return
            }
            
            onCompletion(firstPlace)
        })
        
    }
}
