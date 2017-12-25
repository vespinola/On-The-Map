//
//  AddLocationStep1ViewController.swift
//  OnTheMap
//
//  Created by administrator on 12/22/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class FindLocationViewController: UIViewController {
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationTextField: CustomTextField!
    @IBOutlet weak var infoTextField: CustomTextField!
    
    var delegate: AddLocationProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func findLocationOnTap(_ sender: Any) {
        delegate.findLocation()
    }
}
