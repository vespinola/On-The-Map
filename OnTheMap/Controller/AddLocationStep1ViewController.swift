//
//  AddLocationStep1ViewController.swift
//  OnTheMap
//
//  Created by administrator on 12/22/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class AddLocationStep1ViewController: UIViewController {
    @IBOutlet weak var locationImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    

    @IBAction func findLocationOnTap(_ sender: Any) {
        performSegue(withIdentifier: "addLocationStep2", sender: nil)
    }
}
