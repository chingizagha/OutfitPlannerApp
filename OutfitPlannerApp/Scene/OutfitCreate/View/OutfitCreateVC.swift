//
//  OutfitCreateVC.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 19.05.24.
//

import UIKit

class OutfitCreateVC: UIViewController {
    
    private let viewModel: OutfitCreateViewModel
    
    private let imageView = CustomImageView(frame: .zero)
    private let createButton = CustomButton(backgroundColor: .blue, title: "Create Outfit")
    private let imageButton = CustomButton(backgroundColor: .black, title: "ReCreate")
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = .label
        tf.tintColor = .systemBlue
        tf.textAlignment = .center
        tf.font = .systemFont(ofSize: 17, weight: .semibold)
        
        tf.layer.cornerRadius = 11
        tf.backgroundColor = .secondarySystemBackground
        tf.keyboardType = .decimalPad
        
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 0))
        tf.leftViewMode = .always
        
        tf.attributedPlaceholder = NSAttributedString(string: "Add title...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel])
        tf.autocapitalizationType = .sentences
        tf.autocorrectionType = .default
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    init(viewModel: OutfitCreateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Add Title"
        
        layoutUI()
        var images = [UIImage]()
        for image in viewModel.selectedDressArray {
            let path = ImagePath.shared.getDocumentDirectory().appendingPathComponent(image.imagePath)
            images.append(UIImage(contentsOfFile: path.path)!)
        }
        imageView.image = mergeImages(images: images)
        
        setUpButtons()
    }
    
    private func layoutUI(){
        
        let padding: CGFloat = 20
        
        view.addSubviews(imageView, createButton, imageView, textField)
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.maskedCorners = .layerMaxXMaxYCorner
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            textField.heightAnchor.constraint(equalToConstant: 100),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func mergeImages(images: [UIImage]) -> UIImage? {
        // Calculate the size of the final image
        let imageSize = CGSize(width: images[0].size.width, height: images[0].size.height)
        let finalImageSize = CGSize(width: imageSize.width * CGFloat(images.count), height: imageSize.height)
        
        // Begin a graphics context of sufficient size
        UIGraphicsBeginImageContext(finalImageSize)
        
        // Loop through the images and draw each one in the context
        for (index, image) in images.enumerated() {
            let origin = CGPoint(x: imageSize.width * CGFloat(index), y: 0)
            image.draw(at: origin)
        }
        
        // Get the final image from the context
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return mergedImage
    }
    
    private func setUpButtons(){
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapCreateButton() {
        
        let imageName = UUID().uuidString
        let imagePath = ImagePath.shared.getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = imageView.image!.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let outfit = Outfit()
        outfit.imagePath = imageName
        outfit.title = textField.text
        viewModel.saveOutfit(outfit: outfit)
        navigationController?.popToRootViewController(animated: true)
    }
    

}
