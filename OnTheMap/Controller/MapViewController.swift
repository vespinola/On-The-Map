//
//  ViewController.swift
//  OnTheMap
//
//  Created by administrator on 12/18/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ParseHandler.sharedInstance().studentsLocation.isEmpty {
            ParseHandler.sharedInstance().getStudentLocation(in: self) { students in
                ParseHandler.sharedInstance().studentsLocation = students
                self.performStudentLocation(students)
            }
        } else {
            performStudentLocation(ParseHandler.sharedInstance().studentsLocation)
        }
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func performStudentLocation(_ students: [StudentLocation]) {
        
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(Util.createAnnotations(with: students))
        }
        
    }
    
    @IBAction func logoutButtonOnTap(_ sender: Any) {
        Util.performLogout(in: self) {
            ParseHandler.sharedInstance().clearCache()
            UdacityHandler.sharedInstance().clearCache()
        }
    }
    
    @IBAction func addLocationOnTap(_ sender: Any) {
        performSegue(withIdentifier: "addLocationStep1FromFirstTab", sender: nil)
    }
    
    @IBAction func refreshButtonOnTap(_ sender: Any) {
        ParseHandler.sharedInstance().getStudentLocation(in: self) { students in
            performUIUpdatesOnMain {
                ParseHandler.sharedInstance().studentsLocation = students
                self.performStudentLocation(students)
            }
        }
    }
    
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle {
                app.openURL(URL(string: toOpen!)!)
            }
        }
    }
}
