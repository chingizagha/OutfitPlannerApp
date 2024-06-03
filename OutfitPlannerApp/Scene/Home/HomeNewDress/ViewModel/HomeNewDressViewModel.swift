//
//  HomeNewDressViewModel.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import Foundation

protocol HomeNewDressViewModelDelegate: AnyObject {
    func didAddNewDress() 
}

class HomeNewDressViewModel {
    
    let dress: Dress
    
    var selectedType = ClothesType()
    let pickerData = ClothesType.allCases.map { $0.title }
    
    init(dress: Dress) {
        self.dress = dress
    }
    
    let databaseManager = DatabaseManager()
    
    func saveData(title: String, imagePath: String, type: ClothesType) {
        let dress = Dress()
        dress.title = title
        dress.imagePath = imagePath
        dress.type = type
        databaseManager.saveData(object: dress)
    }
    
}
