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
      let nameLabel = TitleLabel(textAlignment: .center, fontSize: 16)
      
      override init(frame: CGRect) {
          super.init(frame: frame)
          
          layoutUI()
      }
      
      required init?(coder: NSCoder) {
          fatalError()
      }
      
      private func layoutUI(){
          
          contentView.addSubviews(clothesImageView, nameLabel)
          
          NSLayoutConstraint.activate([
              clothesImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
              clothesImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
              clothesImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
              clothesImageView.heightAnchor.constraint(equalTo: clothesImageView.widthAnchor),
              
              nameLabel.topAnchor.constraint(equalTo: clothesImageView.bottomAnchor, constant: 12),
              nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
              nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
              nameLabel.heightAnchor.constraint(equalToConstant: 20)
          ])
      }
      
      func configure(dress: Dress) {
          let path = ImagePath.shared.getDocumentDirectory().appendingPathComponent(dress.imagePath)
          clothesImageView.image = UIImage(contentsOfFile: path.path)
          nameLabel.text = dress.title
      }

}
