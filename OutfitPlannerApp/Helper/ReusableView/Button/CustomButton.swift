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
    
    convenience init(backgroundColor: UIColor, titleColor: UIColor = .systemBackground, icon: String = "", title: String = ""){
        self.init(frame: .zero)
        set(color: backgroundColor, titleColor: titleColor,  icon: icon, title: title)
    }
    
    private func configure(){
        configuration = .bordered()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(color: UIColor, titleColor: UIColor = .systemBackground, icon: String = "", title: String = ""){
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = titleColor
        configuration?.title = title
        
        configuration?.image = UIImage(systemName: "\(icon)")
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
}

#Preview() {
    CustomButton(backgroundColor: .clear, icon: "pencil", title: "Magic")
}






