//
//  SegmentedCell.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 26.05.24.
//

import UIKit

class SegmentedCell: UICollectionViewCell {
    
    static let identifier = "SegmentedCell"
    
    let padding: CGFloat = 8
        
    let nameLabel = TitleLabel(textAlignment: .center, fontSize: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .label: .systemBackground
            nameLabel.textColor = isSelected ? .systemBackground: .label
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func layoutUI(){
        
        contentView.backgroundColor = .systemBackground
        nameLabel.textColor = .label
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.addSubviews(nameLabel)
        
        contentView.layer.cornerRadius = 25 // Adjust as needed for your design
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the corner radius is updated if the cell's frame changes
        contentView.layer.cornerRadius = contentView.frame.height / 2
    }
    
    func configure(title: String) {
        nameLabel.text = title
    }
    
}
