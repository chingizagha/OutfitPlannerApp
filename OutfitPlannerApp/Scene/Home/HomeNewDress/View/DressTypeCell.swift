//
//  DressItemCell.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import UIKit

class DressTypeCell: UICollectionViewCell {

    static let identifier = "DressTypeCell"
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .black : .white
            titleImageView.tintColor = isSelected ? .white : .black
        }
    }
    
    private let titleImageView = CustomImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func layoutUI(){
        
        contentView.backgroundColor = .white
        titleImageView.tintColor = .black
        
        addSubviews(titleImageView)

        titleImageView.contentMode = .scaleAspectFit
        
        contentView.layer.borderWidth = 1.1
        contentView.layer.borderColor = CGColor(red: 49.0/255.0, green: 49.0/255.0, blue: 49.0/255.0, alpha: 1.0)

        
        contentView.layer.cornerRadius = contentView.frame.size.width / 2
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the corner radius is updated if the cell's frame changes
        contentView.layer.cornerRadius = contentView.frame.height / 2
    }
    
    func configure(with image: String){
        titleImageView.image = UIImage(systemName: image)
    }

}
