//
//  Dress.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import RealmSwift

enum ClothesType: Int, PersistableEnum, RealmFetchable {
    case jacket
    case shirt
    case pants
    case shoes
    case extras
    
    var title: String {
        switch self {
        case .jacket:
            return "Jacket"
        case .shirt:
            return "Shirt"
        case .pants:
            return "Pants"
        case .shoes:
            return "Shoes"
        case .extras:
            return "Extras"
        }
        
    }
    
    var icon: String {
        switch self {
        case .jacket:
            return "tshirt"
        case .shirt:
            return "tshirt"
        case .pants:
            return "tshirt"
        case .shoes:
            return "shoe"
        case .extras:
            return "tshirt"
        }
    }
    
    var number: Int {
        switch self {
        case .jacket:
            return 0
        case .shirt:
            return 1
        case .pants:
            return 2
        case .shoes:
            return 3
        case .extras:
            return 4
        }
    }
}

class Dress: Object {
    @Persisted var title: String?
    @Persisted var imagePath: String
    @Persisted var type: ClothesType
}


