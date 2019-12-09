//
//  HypeController.swift
//  GetHype
//
//  Created by Aaron Shackelford on 12/9/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import Foundation
import CloudKit

class HypeController {
    
    static let shared = HypeController()
    
    var hypes = [Hype]()
    //our public database in the icloud servers
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //save a hype
    func saveHype(with body: String, completion: @escaping (Bool) -> Void){
        //create a hype
        let hype = Hype(body: body)
        //turn hype into a CKRecord
        let record = CKRecord(hype: hype)
        
        //saving our record to public db
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                return completion(false)
            }
            //check to see if record exists
            guard let record = record,
                //check to see it successfully decoded/initialized
                let hype = Hype(ckRecord: record) else { return  completion(false) }
            
            //add hype to SOT
            self.hypes.insert(hype, at: 0)
            print("Hype saved successfully.")
            //complete successfully
            completion(true)
        }
    }
    //fetch all hypes
    func fetchAllHypes(completion: @escaping (Bool) -> Void) {
        
        //predicate determines which hypes are returned from the server
        let predicate = NSPredicate(value: true)
        //creating query in order to serach the DB
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: predicate)
        
        //searching the DB with the query
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            //error handling
            if let error = error {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                return completion(false)
            }
            //check to see if records came back
            guard let records = records else { return completion(false) }
            //creating new array of hypes
            let hypes = records.compactMap {
                Hype(ckRecord: $0) //$0 and remove "record in"
            }
            
            //updating SOT
            self.hypes = hypes
            
            print("Successfully fetched Hypes")
            completion(true)
        }
        
    }
}
