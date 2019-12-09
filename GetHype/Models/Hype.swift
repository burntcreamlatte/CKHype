//
//  Hype.swift
//  GetHype
//
//  Created by Aaron Shackelford on 12/9/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import Foundation
import CloudKit

// MARK: - Constants
enum HypeStrings {
    static let recordTypeKey = "Hype"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
}
//our model, basically a simple post
class Hype {
    let body: String
    let timestamp: Date
    
    init(body: String, timestamp: Date = Date()) {
        self.body = body
        self.timestamp = timestamp
    }
}
//incoming <- take a record from the server and turn it back into a Hype
extension Hype {
    convenience init?(ckRecord: CKRecord) {
        //pulling individual values off of the CKRecord
        //have to typecast so that the compiler knows how to treat the values
        guard let body = ckRecord[HypeStrings.bodyKey] as? String, let timestamp = ckRecord[HypeStrings.timestampKey] as? Date else { return nil }
        
        self.init(body: body, timestamp: timestamp)
    }
}


// MARK: - CKRecord

//outgoing -> turn a hype into a CKRecord and send it to the server
extension CKRecord {
    //setting key:value pairs on the CKRecord based off of our Hype object
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrings.recordTypeKey)
        setValue(hype.body, forKey: HypeStrings.bodyKey)
        setValue(hype.timestamp, forKey: HypeStrings.timestampKey)
        
//        setValuesForKeys([
//            "body" : hype.body
//            "timestamp" : hype.timestamp
//        ])
    }
}
