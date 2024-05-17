//
//  ImagePath.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import Foundation

class ImagePath {
    
    static let shared = ImagePath()
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
