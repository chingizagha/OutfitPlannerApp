//
//  HomeViewModel.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import Foundation

class HomeViewModel {
    
    var dressArray = [Dress]()
    var filteredDressArray = [Dress]()
    
    let databaseManager = DatabaseManager()
    
    func fetchData() {
        dressArray = databaseManager.fetchData()
    }
    
   
    
    func deleteData(dress: Dress) {
        databaseManager.deleteData(dress: dress)
    }
    
    func filterDress(_ type: ClothesType) {
        filteredDressArray = dressArray.filter { $0.type == type }
    }
}
