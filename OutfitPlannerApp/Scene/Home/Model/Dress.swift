//
//  Dress.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import RealmSwift

enum ClothesType: Int, PersistableEnum, RealmFetchable {
    case jacket
    case tshirt
    case jeans
    case shoes
    case accessory
    
    var title: String {
        switch self {
        case .jacket:
            return "Top"
        case .tshirt:
            return "Medium"
        case .jeans:
            return "Bottom"
        case .shoes:
            return "Other"
        case .accessory:
            return "Accessory"
        }
        
    }
    
    var number: Int {
        switch self {
        case .jacket:
            return 0
        case .tshirt:
            return 1
        case .jeans:
            return 2
        case .shoes:
            return 3
        case .accessory:
            return 4
        }
    }
}

class Dress: Object {
    @Persisted var title: String?
    @Persisted var imagePath: String
    @Persisted var type: ClothesType
}


