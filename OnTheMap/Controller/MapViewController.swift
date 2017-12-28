//
//  ViewController.swift
//  OnTheMap
//
//  Created by administrator on 12/18/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: CustomViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations: [MKPointAnnotation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if ParseHandler.sharedInstance().studentsLocation.isEmpty {
            refrestStudentsLocation()
        } else {
            performStudentLocation(annotations)
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
        refrestStudentsLocation()
    }
    
    func refrestStudentsLocation() {
        
        mapView.removeAnnotations(annotations)
        
        ParseHandler.sharedInstance().getStudentLocation(in: self) { students in
            performUIUpdatesOnMain {
                ParseHandler.sharedInstance().studentsLocation = students
                self.annotations = Util.createAnnotations(with: students)
                self.performStudentLocation(self.annotations)
            }
        }
    }
    
    func performStudentLocation(_ students: [MKPointAnnotation]) {
        
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(students)
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
        if let toOpen = view.annotation?.subtitle, control == view.rightCalloutAccessoryView {
            Util.openURL(with: toOpen ?? "")
        }
    }
}
