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
    
    var studentLocation: StudentInformation!
    
    var annotations: [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        annotations = Util.createAnnotations(with: [self.studentLocation])
        
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(self.annotations)
            self.mapView.showAnnotations(self.annotations, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        performUIUpdatesOnMain {
            self.mapView.removeAnnotations(self.annotations)
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
        }else {
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
