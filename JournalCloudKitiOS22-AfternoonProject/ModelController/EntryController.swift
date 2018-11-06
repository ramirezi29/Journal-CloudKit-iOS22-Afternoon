//
//  EntryController.swift
//  JournalCloudKitiOS22-AfternoonProject
//
//  Created by Ivan Ramirez on 11/5/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

class EntryController {
    
    // MARK: - Shared Instance
    static let shared = EntryController()
    private init (){}
    
    // MARK: - Funte De Verdad
    var entries: [Entry] = []
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    // MARK: - Save
    func saveEntry(with entry: Entry, completion: @escaping (Bool) -> Void) {
        let entryRecord = CKRecord(enty: entry)
        privateDatabase.save(entryRecord) { (record, error) in
            if let error = error {
                print("\n\n🚀 There was an error with saving data to iCloud in: \(#file) \n\n \(#function); \n\n\(error); \n\n\(error.localizedDescription) 🚀\n\n")
                completion(false)
                return
            }
            guard let record = record,
                let newEntry = Entry(ckRecord: record) else {
                    completion(false)
                    return
            }
            self.entries.append(newEntry)
            completion(true)
        }
    }
    
    // MARK: - Add
    
    func createEntryWith(title: String, textBody: String, completion: @escaping (Bool) -> Void) {
        
        let entry = Entry(title: title, textBody: textBody)
        
        self.saveEntry(with: entry) { (success) in
            if success {
                print("Successfully created record")
                completion(true)
            } else {
                completion(false)
                fatalError("Error creating Record")
            }
        }
    }
    
    // MARK: - Update
    func updateEntry(entry: Entry, title: String, textBody: String, completion: @escaping (Bool) -> Void) {
        entry.title = title
        entry.textBody = textBody
        let record = CKRecord(enty: entry)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        operation.completionBlock = {
            completion(true)
        }
        privateDatabase.add(operation)
        //dont complete uneless its all compeleted
    }
    
    // MARK: - Fetch
    func fetchEntries(completion: @escaping ([Entry]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.EntryTypeKey, predicate: predicate)
        
        //
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("\n\n🚀 There was an error with fetching entries from iCloud in: \(#file) \n\n \(#function); \n\n\(error); \n\n\(error.localizedDescription) 🚀\n\n")
                completion(nil)
                return
            }
            guard let records = records else {completion(nil); return}
            let entries = records.compactMap{Entry(ckRecord: $0)}
            self.entries = entries
            completion(entries)
        }
    }
}

