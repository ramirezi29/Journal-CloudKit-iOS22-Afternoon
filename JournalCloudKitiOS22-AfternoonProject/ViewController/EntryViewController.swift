//
//  EntryViewController.swift
//  JournalCloudKitiOS22-AfternoonProject
//
//  Created by Ivan Ramirez on 11/5/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var tableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        activityIndicator.isHidden = true
        activityView.backgroundColor = UIColor.clear
        
        // MARK: - Fetch
        
        EntryController.shared.fetchEntries { (entries) in
            if (entries != nil) {
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()
                }
            } else {
                self.presentAlertController()
                print("error Fetcign data")
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableViewOutlet.reloadData()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let destiantionVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableViewOutlet.indexPathForSelectedRow else {return}
            let entry = EntryController.shared.entries[indexPath.row]
            destiantionVC.entry = entry
        }
    }
}

extension EntryViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else {return UITableViewCell()}
        let entry = EntryController.shared.entries[indexPath.row]
        
        cell.entry = entry
        
        return cell
    }
}

extension EntryViewController {
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        EntryController.shared.fetchEntries { (entries) in
            if (entries != nil) {
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()
                }
            } else {
                self.presentAlertController()
                print("error Fetcign data")
                return
            }
        }
    }
}

extension EntryViewController {
    func presentAlertController() {
        let alertController = UIAlertController(title: "💀Error Fetching Your Entries 💀", message: "Please don't give me a bad review on the App Store", preferredStyle: .alert)
        
        // NOTE: - Dismiss
        let dismissAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
