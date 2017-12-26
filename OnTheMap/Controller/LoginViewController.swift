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
            NSAttributedStringKey.font: Constants.Fonts.standard,
            NSAttributedStringKey.foregroundColor : Constants.Colors.lightBlue
        ]))
        
        registerButton.setAttributedTitle(titleAttributedString, for: .normal)
        
        passwordTextfield.isSecureTextEntry = true
        usernameTextfield.keyboardType = .emailAddress
        
    }

    @IBAction func loginButtonOnTap(_ sender: Any) {
        guard let username = usernameTextfield.text, !username.isEmpty else {
            Util.showAlert(for: "You must enter an email", in: self)
            return
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            Util.showAlert(for: "You must enter a password", in: self)
            return
        }
        
        let parameters = [
            "username" : username,
            "password" : password
        ]
        
        [usernameTextfield, passwordTextfield].forEach {
            $0?.resignFirstResponder()
        }
        
        UdacityHandler.sharedInstance().postSession(with: parameters, in: self, onCompletion: { session in
            
            UdacityHandler.sharedInstance().udacitySession = session
            
            UdacityHandler.sharedInstance().getUserData(in: self) { userData in
                
                UdacityHandler.sharedInstance().udacityUserData = userData
                
                self.performSegue(withIdentifier: Constants.Segues.home, sender: nil)
            }
            
        })
        
    }
    
    @IBAction func registerButtonOnTap(_ sender: Any) {
        Util.openURL(with: "https://www.udacity.com/account/auth#!/signup")
    }
}
