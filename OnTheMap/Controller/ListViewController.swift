//
//  ListViewController.swift
//  OnTheMap
//
//  Created by User on 12/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var listTableView: UITableView!

    var students: [StudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        students = ParseHandler.sharedInstance().studentsLocation
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
