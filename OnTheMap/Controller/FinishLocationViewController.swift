//
//  FinishLocationViewController.swift
//  OnTheMap
//
//  Created by User on 12/24/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class FinishLocationViewController: UIViewController {

    var delegate: AddLocationProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func finishButtonOnTap(_ sender: Any) {
        delegate.finish()
    }
}
