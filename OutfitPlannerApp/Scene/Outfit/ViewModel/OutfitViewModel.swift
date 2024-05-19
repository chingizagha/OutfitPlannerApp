//
//  OutfitViewModel.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 17.05.24.
//

import Foundation

class OutfitViewModel {
    
    var outfitArray = [Outfit]()
    
    let databaseManager = DatabaseManager()
    
    func fetchData() {
        outfitArray = databaseManager.fetchData()
    }
    
    func deleteData(outfit: Outfit) {
        databaseManager.deleteData(object: outfit)
    }
}
