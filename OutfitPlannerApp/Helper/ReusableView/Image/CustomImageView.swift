//
//  CustomImageView.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import UIKit

class CustomImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        //image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

}
