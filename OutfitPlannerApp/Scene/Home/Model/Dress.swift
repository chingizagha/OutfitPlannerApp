//
//  Dress.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import RealmSwift

enum ClothesType: Int, PersistableEnum {
    case top
    case mid
    case bottom
    case other
    
    var title: String {
        switch self {
        case .top:
            return "Top"
        case .mid:
            return "Medium"
        case .bottom:
            return "Bottom"
        case .other:
            return "Other"
        }
        
    }
    
    var number: Int {
        switch self {
        case .top:
            return 0
        case .mid:
            return 1
        case .bottom:
            return 2
        case .other:
            return 3
        }
    }
}

class Dress: Object {
    @Persisted var title: String?
    @Persisted var imagePath: String
    @Persisted var type: ClothesType
}


