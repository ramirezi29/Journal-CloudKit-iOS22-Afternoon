//
//  EntryViewController.swift
//  JournalCloudKitiOS22-AfternoonProject
//
//  Created by Ivan Ramirez on 11/5/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class EntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var toolBarOutlet: UIToolbar!
    @IBOutlet weak var trashCanOutlet: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - TableView outlet
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
        
        // MARK: - Activity Indicator and View
        activityIndicator.isHidden = true
        activityView.backgroundColor = UIColor.clear
        activityIndicator.color = UIColor(red: 0.3, green: 165/255, blue: 0.09, alpha: 1)
        
        // MARK: - tool bar
        self.toolBarOutlet.isHidden = true
        
        // MARK: - Fetch
        // when app loads all the posts show up 
        EntryController.shared.fetchEntries { (entries) in
            if (entries != nil) {
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                }
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
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
    
    // MARK: - Action: Edit Button Tapped
    @IBAction func editButtonTapped(_ sender: Any) {
        
        self.tableViewOutlet.setEditing(!tableViewOutlet.isEditing, animated: true)
        
        if self.tableViewOutlet.isEditing &&  self.toolBarOutlet.isHidden == true {
            
            self.toolBarOutlet.isHidden = false
            self.tableViewOutlet.allowsMultipleSelection = true
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editButtonTapped(_:)))
        } else {
            
            if self.toolBarOutlet.isHidden == false {
                
                self.toolBarOutlet.isHidden = true
                
                self.tableViewOutlet.allowsMultipleSelection = false
                navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
            }
        }
    }
}

// MARK: - Action Delete Button
extension EntryViewController {
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        //guard var cellsToDelete = self.tableViewOutlet.indexPathsForSelectedRows,
        
    }
}

// MARK: - DataSource

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
    
    
    // MARK: - Edit Delete DataSource
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entryRecord =
                EntryController.shared.entries[indexPath.row]
            
            /*CKModifyRecordsOperation: After modifying the fields of a record, use this type of operation object to save those changes to a database. You also use instances of this class to delete records permanently from a database.*/
            //  let ckRecordIDToDelte = CKModifyRecordsOperation.init(recordsToSave: <#T##[CKRecord]?#>, recordIDsToDelete: <#T##[CKRecord.ID]?#>)
            
            
            // let ckCKckdelete = CKRecord_Reference_Action.deleteSelf
            
            EntryController.shared.privateDatabase.delete(withRecordID: entryRecord.ckRecordID) { (_, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.presentAlertController()
                    }
                } else {
                    EntryController.shared.entries.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.tableViewOutlet.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let entry = EntryController.shared.entries[sourceIndexPath.row]
        EntryController.shared.entries.remove(at: sourceIndexPath.row)
        EntryController.shared.entries.insert(entry, at: destinationIndexPath.row)
    }
    
}

// MARK: - Action: Refresh Button
extension EntryViewController {
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        EntryController.shared.fetchEntries { (entries) in
            if (entries != nil) {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                }
                
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()
                    
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            } else {
                self.presentAlertController()
                print("error Fetcign data")
                return
            }
        }
    }
}

// MARK: - Alert
extension EntryViewController {
    func presentAlertController() {
        let alertController = UIAlertController(title: "💀 Network Error 💀", message: "Please don't give me a bad review on the App Store", preferredStyle: .alert)
        
        // NOTE: - Dismiss
        let dismissAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}

