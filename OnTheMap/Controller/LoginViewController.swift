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

        logoImageView.contentMode = .scaleAspectFit
        
        let titleAttributedString = NSMutableAttributedString()
        
        titleAttributedString.append(NSMutableAttributedString(string: "Don't have an account? ", attributes: [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor : UIColor.black
        ]))
        
        titleAttributedString.append(NSMutableAttributedString(string: "Sign Up", attributes: [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor : UIColor(netHex:  0x02B3E4)
        ]))
        
        registerButton.setAttributedTitle(titleAttributedString, for: .normal)
        
    }

    @IBAction func loginButtonOnTap(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.home, sender: nil)
    }
    
    @IBAction func registerButtonOnTap(_ sender: Any) {
        
    }
}
