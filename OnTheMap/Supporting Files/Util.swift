//
//  Util.swift
//  OnTheMap
//
//  Created by User on 12/19/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit
import MapKit

typealias OTMDictionary = [String: Any]

enum HTTPMethod {
    case post
    case get
    case put
    case delete
    
    func method() -> String {
        switch self {
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        default:
            return "GET"
        }
    }
}

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

class Util {
    
    class func showAlert(for message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func prepareForJsonBody(_ dictionary: OTMDictionary) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        return jsonData
    }
    
    class func performLogout(in viewController: UIViewController, with callback: (() -> Void)? = nil) {
        UdacityHandler.sharedInstance().deleteSession(in: viewController, onCompletion: { _ in
            performUIUpdatesOnMain {
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
                
                ParseHandler.sharedInstance().clearCache()
                UdacityHandler.sharedInstance().clearCache()
                
                UIView.transition(with: viewController.view, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    appdelegate.window!.rootViewController = homeViewController
                    callback?()
                }, completion: nil)
            }
        })
    }
    
    class func openURL(with string: String) {
        //from https://stackoverflow.com/a/39546889
        guard let url = URL(string: string) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    class func createAnnotations(with studentsLocation: [StudentInformation]) -> [MKPointAnnotation]{
        var annotations:[MKPointAnnotation] = []
        
        studentsLocation.forEach { student in
            
            if let studentLat = student.latitude, let studentLong = student.longitude {
                let lat = CLLocationDegrees(studentLat)
                let long = CLLocationDegrees(studentLong)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = student.firstName!
                let last = student.lastName!
                let mediaURL = student.mediaURL!
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
            }
            
        }
        
        return annotations
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
