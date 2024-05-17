//
//  OutfitSelectViewModel.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 17.05.24.
//

import Foundation

class OutfitSelectViewModel {
    
    var dressArray = [Dress]()
    
    let databaseManager = DatabaseManager()
    
    func fetchData() {
        dressArray = databaseManager.fetchData()
    }
}
