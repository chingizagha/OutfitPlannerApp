//
//  Outfit.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 17.05.24.
//

import RealmSwift

class Outfit: Object {
    @Persisted var title: String?
    @Persisted var imagePath: String	
}
