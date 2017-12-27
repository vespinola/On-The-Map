//
//  FinishLocationViewController.swift
//  OnTheMap
//
//  Created by User on 12/24/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit
import MapKit

class FinishLocationViewController: CustomViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: AddLocationProtocol!
    
    var studentLocation: StudentLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(Util.createAnnotations(with: [self.studentLocation]))
        }
    }
    
    @IBAction func finishButtonOnTap(_ sender: Any) {
        delegate.finish()
    }
}

extension FinishLocationViewController: MKMapViewDelegate {
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
