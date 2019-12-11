//
//  UserController.swift
//  GetHype
//
//  Created by Aaron Shackelford on 12/10/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    static let shared = UserController()
    var currentUser: User?
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    func createUser(with username: String, bio: String completion: @escaping (Bool) -> Void) {
        fetchAppleUserReference { (reference) in
            guard let reference = reference else { completion(false); return }
            let newUser = User(username: username, bio: bio, appleUserReference: reference)
            let record = CKRecord(user: newUser)
            
            self.publicDB.save(record) { (record, error) in
                if let error = error {
                    print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                    completion(false); return
                }
                
                guard let record = record,
                    let savedUser = User(ckRecord: record) else { completion(false); return }
                self.currentUser = savedUser
                print("Created user: \(record.recordID.recordName) successfully.")
                completion(true)
            }
        }
    }
    func fetchUser(completion: @escaping (Bool) -> Void) {
        
        fetchAppleUserReference { (reference) in
            guard let reference = reference else { completion(false); return}
        
            let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserStrings.appleUserReferenceKey, reference])
            
            let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
            
            self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
                if let error = error {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                completion(false); return
                }
                guard let record = records?.first,
                    let foundUser = User(ckRecord: record) else { completion(false); return }
                self.currentUser = foundUser
                print("Fetched User: \(record.recordID.recordName) successfully.")
                completion(true)
            }
            
            
        }
    }
    
    private func fetchAppleUserReference(completion: @escaping (CKRecord.Reference?) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                completion(nil); return
            }
            guard let recordID = recordID else { completion(nil); return }
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            completion(reference)
        }
    }
    
    func updateUser() {
        
    }
    
    func deleteUser() {
        
    }
}
