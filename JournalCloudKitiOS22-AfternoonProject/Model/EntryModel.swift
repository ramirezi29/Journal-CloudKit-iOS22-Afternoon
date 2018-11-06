//
//  EntryModel.swift
//  JournalCloudKitiOS22-AfternoonProject
//
//  Created by Ivan Ramirez on 11/5/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    
    var title: String
    var textBody: String?
    var timestamp: Date
    let ckRecordID: CKRecord.ID
    
    
    init(title: String, textBody: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.timestamp = Date()
        self.textBody = textBody
        self.ckRecordID = ckRecordID
    }
    
    var timeStampAsString: String {
        return DateFormatter.localizedString(from: timestamp, dateStyle: .short, timeStyle: .none)
    }
    
    // NOTE: - Create a model object fromR a CKRecord -- 🔥Fetch
    convenience init?(ckRecord: CKRecord) {
        //🍕 Step 1. Unpack the values that i want from the CKREcord
        guard let title = ckRecord[Constants.titleKey] as? String,
            let textBody = ckRecord[Constants.textBodyKey] as? String else {return nil}
        //🍕 Step 2. Set tthose values as my initial values for my new instance
        self.init(title: title, textBody: textBody, ckRecordID: ckRecord.recordID)
        
    }
}

// NOTE: - Create a CKRecord using our model object -- 🔥Push
extension CKRecord {
    convenience init(enty: Entry) {
        self.init(recordType: Constants.EntryTypeKey, recordID: enty.ckRecordID)
        self.setValue(enty.title, forKey: Constants.titleKey)
        self.setValue(enty.textBody, forKey: Constants.textBodyKey)
        self.setValue(enty.timestamp, forKey: Constants.timestampKey)
    }
}

struct Constants {
    static let EntryTypeKey = "Entry"
    static let titleKey = "title"
    static let textBodyKey = "textBody"
    static let timestampKey = "timestamp"
}


