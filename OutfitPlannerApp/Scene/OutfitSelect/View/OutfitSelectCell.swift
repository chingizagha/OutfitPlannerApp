//
//  OutfitSelectCell.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 17.05.24.
//

import UIKit

class OutfitSelectCell: UITableViewCell {
    
    static let identifier = "OutfitSelectCell"
    
    private let titleImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 21
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func layoutUI(){
        
        addSubviews(titleImageView)
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            titleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleImageView.heightAnchor.constraint(equalToConstant: 30),
            titleImageView.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configure(dress: Dress){
        let path = ImagePath.shared.getDocumentDirectory().appendingPathComponent(dress.imagePath)
        titleImageView.image = UIImage(contentsOfFile: path.path)
    }


}
