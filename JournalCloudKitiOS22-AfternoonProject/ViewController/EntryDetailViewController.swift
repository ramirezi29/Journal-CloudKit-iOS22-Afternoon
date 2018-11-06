//
//  EntryDetailViewController.swift
//  JournalCloudKitiOS22-AfternoonProject
//
//  Created by Ivan Ramirez on 11/5/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit
import AVFoundation

class EntryDetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textBodyTextField: UITextView!
    
    // MARK: - Landing pad
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewIfNeeded()
        updateViews()
    }
    
    // MARK: - Update
    func updateViews(){
        guard let entry = entry else {return}
        titleTextField.text = entry.title
        textBodyTextField.text = entry.textBody
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            let textBody = textBodyTextField.text else {return}
        textBodyTextField.resignFirstResponder()
        
        if let entry = entry {
            EntryController.shared.updateEntry(entry: entry, title: title, textBody: textBody) { (success) in
                if success {
                    print("Success Updating Entry")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.presentAlertController()
                    print("error with the upating the data")
                    return
                }
            }
        } else {
            EntryController.shared.createEntryWith(title: title, textBody: textBody) { (success) in
                if success {
                    print("\n\nCreating new entry successful\n\n")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.presentAlertController()
                    print("💀 \n\nError creating new entry\n\n")
                    return
                }
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        textBodyTextField.text = ""
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension EntryDetailViewController {
    func presentAlertController() {
        let alertController = UIAlertController(title: "💀 There was a networking error 💀", message: "Please don't give me a bad review on the App Store", preferredStyle: .alert)
        
        // NOTE: - Dismiss
        let dismissAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
