//
//  CustomButton.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
     convenience init(backgroundColor: UIColor, title: String){
        self.init(frame: .zero)
        set(color: backgroundColor, title: title)
    }
    
    private func configure(){
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(color: UIColor, title: String){
        configuration?.baseBackgroundColor = .systemGray
        configuration?.baseForegroundColor = color
        configuration?.title = title
    }
}
