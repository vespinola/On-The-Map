//
//  ListViewController.swift
//  OnTheMap
//
//  Created by User on 12/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class ListViewController: CustomViewController {
    @IBOutlet weak var listTableView: UITableView!

    var students: [StudentInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        students = StudentInformation.studentsLocation
    }
    
    @IBAction func logoutButtonOnTap(_ sender: Any) {
        Util.performLogout(in: self)
    }
    
    @IBAction func addLocatonButtonOnTap(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.addLocationFromList, sender: nil)
    }
    
    @IBAction func refreshButtonOnTap(_ sender: Any) {
        ParseHandler.sharedInstance().getStudentLocation(in: self) { students in
            performUIUpdatesOnMain {
                StudentInformation.studentsLocation = students
                self.students = students
                self.listTableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        guard let mediaURL = student.mediaURL else { return }
        Util.openURL(with: mediaURL)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath)
        let student = students[indexPath.row]
        
        cell.textLabel?.text = (student.firstName ?? "") + " " + (student.lastName ?? "")
        cell.detailTextLabel?.text = student.mediaURL ?? ""
        
        return cell
    }
    
    
}
