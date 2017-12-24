//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by User on 12/24/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    @IBOutlet weak var firstContainer: UIView!
    @IBOutlet weak var secondContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cancelButtonOnTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
