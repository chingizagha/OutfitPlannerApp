//
//  DressCell.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import UIKit

class DressCell: UICollectionViewCell {
    
    static let identifier = "DressCell"
      
    let padding: CGFloat = 8
    
    let clothesImageView = CustomImageView(frame: .zero)
    //let nameLabel = TitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func layoutUI(){
        
        contentView.addSubviews(clothesImageView)
        
        NSLayoutConstraint.activate([
            clothesImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            clothesImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            clothesImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            clothesImageView.heightAnchor.constraint(equalTo: clothesImageView.widthAnchor, constant: -padding),
        ])
    }
    
    func configure(dress: Dress) {
        let path = ImagePath.shared.getDocumentDirectory().appendingPathComponent(dress.imagePath)
        clothesImageView.image = UIImage(contentsOfFile: path.path)
    }
    
}
