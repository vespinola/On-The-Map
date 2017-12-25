//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by User on 12/24/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

protocol AddLocationProtocol {
    func findLocation()
    func finish()
}

//from https://www.efectoapple.com/implementando-container-view-controller/

class AddLocationViewController: UIViewController {
    @IBOutlet weak var firstContainer: UIView!
    
    var findLocationViewController: FindLocationViewController?
    var finishLocationViewController: FinishLocationViewController?
    
    private var activeViewController: UIViewController? {
        didSet {
            remove(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        finishLocationViewController = storyboard.instantiateViewController(withIdentifier: "FinishLocationViewControllerID") as? FinishLocationViewController
        findLocationViewController = storyboard.instantiateViewController(withIdentifier: "FindLocationViewControllerID") as? FindLocationViewController
        
        finishLocationViewController?.delegate = self
        findLocationViewController?.delegate = self
        
        activeViewController = findLocationViewController
    }
    
    private func remove(inactiveViewController: UIViewController?) {
        guard let inactiveVC = inactiveViewController else { return }
        
        inactiveVC.willMove(toParentViewController: nil)
        inactiveVC.view.removeFromSuperview()
        inactiveVC.removeFromParentViewController()
    }
    
    private func updateActiveViewController() {
        guard let activeVC = activeViewController else { return }
        
        activeVC.view.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            activeVC.view.alpha = 1
        })
        
        addChildViewController(activeVC)
        activeVC.view.frame = firstContainer.bounds
        firstContainer.addSubview(activeVC.view)
        activeVC.didMove(toParentViewController: self)
    }

    @IBAction func cancelButtonOnTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddLocationViewController: AddLocationProtocol {
    func findLocation() {
        activeViewController = finishLocationViewController
    }
    
    func finish() {
        dismiss(animated: true, completion: nil)
    }
}
