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
    
    convenience init(backgroundColor: UIColor, icon: String = "", title: String = ""){
        self.init(frame: .zero)
        set(color: backgroundColor, icon: icon, title: title)
    }
    
    private func configure(){
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(color: UIColor, icon: String = "", title: String = ""){
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title
        
        configuration?.image = UIImage(systemName: "\(icon)")
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
}

#Preview() {
    CustomButton(backgroundColor: .systemGray, icon: "pencil", title: "Magic")
}
