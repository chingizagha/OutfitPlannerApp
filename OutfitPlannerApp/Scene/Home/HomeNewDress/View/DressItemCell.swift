//
//  DressItemCell.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import UIKit

class DressItemCell: UITableViewCell {

    static let identifier = "ItemCell"
    
    private let titleImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 21
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let titleLabel = BodyLabel(textAlignment: .center)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func layoutUI(){
        addSubviews(titleImageView, titleLabel)
        accessoryType = .disclosureIndicator
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            titleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleImageView.heightAnchor.constraint(equalToConstant: 30),
            titleImageView.widthAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 24),
            titleLabel.widthAnchor.constraint(equalToConstant: 120),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with image: UIImage, text: String){
        titleImageView.image = image
        titleLabel.text = text
    }

}
