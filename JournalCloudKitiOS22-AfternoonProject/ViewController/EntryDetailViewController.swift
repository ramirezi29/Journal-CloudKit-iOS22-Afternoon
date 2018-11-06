//
//  EntryDetailViewController.swift
//  JournalCloudKitiOS22-AfternoonProject
//
//  Created by Ivan Ramirez on 11/5/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

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
    EntryController.shared.saveEntry(with: <#T##Entry#>, completion: <#T##(Bool) -> Void#>)
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        titleTextField.text = ""
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
