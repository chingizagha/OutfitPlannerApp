//
//  CoreDataManager.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import UIKit
import RealmSwift

enum DatabaseError: String, Error {
    case failedToSaveData
    case failedToLoadData
    case failedToDeleteData
}

enum PersistenceActionType {
    case add, remove
}

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    init() {
        
    }
    
    let realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 2))
    
    // Fetch data
    func fetchData() -> [Dress] {
        return realm.objects(Dress.self).map( { $0 })
    }

    // Save data
    func saveData(dress: Dress) {
        
        try! realm.write {
            realm.add(dress)
        }
    }

    // Delete data
    func deleteData(dress: Dress) {
        
        try! realm.write {
            realm.delete(dress)
        }
    }
    
    

}
