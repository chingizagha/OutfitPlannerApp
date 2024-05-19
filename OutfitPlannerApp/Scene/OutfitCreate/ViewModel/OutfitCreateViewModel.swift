//
//  OutfitCreateViewModel.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 19.05.24.
//

import Foundation

class OutfitCreateViewModel {
    
    let selectedDressArray: [Dress]
    
    let databaseManager = DatabaseManager()
    
    init(selectedDressArray: [Dress]) {
        self.selectedDressArray = selectedDressArray
    }
    
    func saveOutfit(outfit: Outfit) {
        databaseManager.saveData(object: outfit)
    }
}
