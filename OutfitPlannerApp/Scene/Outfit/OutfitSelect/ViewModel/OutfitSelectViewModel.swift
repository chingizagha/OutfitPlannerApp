//
//  OutfitSelectViewModel.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 17.05.24.
//

import Foundation

class OutfitSelectViewModel {
    
    var dressArray = [Dress]()
    
    var jacketArray = [Dress]()
    var tshirtArray = [Dress]()
    var jeansArray = [Dress]()
    var shoesArray = [Dress]()
    var otherArray = [Dress]()
    
    var selectedDressArray = [Dress]()
    
    let databaseManager = DatabaseManager()
    
    func fetchData() {
        dressArray = databaseManager.fetchData()
    }
    
//    func getSelectedDresses(selectedRows: [String: IndexPath]) -> [Dress] {
//        
//    }
    
}
