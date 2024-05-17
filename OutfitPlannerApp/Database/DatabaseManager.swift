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
    
    let realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 3))
    
    // Fetch data
    func fetchData<T: Object>() -> [T] {
        return realm.objects(T.self).map( { $0 })
    }

    // Save data
    func saveData<T: Object>(object: T) {
        
        try! realm.write {
            realm.add(object)
        }
    }

    // Delete data
    func deleteData<T: Object>(object: T) {
        
        try! realm.write {
            realm.delete(object)
        }
    }
    
    

}
