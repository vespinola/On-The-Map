//
//  CustomViewController.swift
//  OnTheMap
//
//  Created by User on 12/26/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    
    let alphaPercentage: CGFloat = 0.7
    
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(alphaPercentage)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(activityIndicator)
    }
    
    func showActivityIndicatory() {
        
        performUIUpdatesOnMain {
            self.view.isUserInteractionEnabled = false
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.activityIndicator.startAnimating()
        }
        
    }
    
    func hideActivityIndicator() {
        performUIUpdatesOnMain {
            self.view.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
        }
    }

}
