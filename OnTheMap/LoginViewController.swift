//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by administrator on 12/19/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonOnTap(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.home, sender: nil)
    }
    
    @IBAction func registerButtonOnTap(_ sender: Any) {
        
    }
}
