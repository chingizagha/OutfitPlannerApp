//
//  HomeNewDressVC.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 12.05.24.
//

import UIKit

class HomeNewDressVC: UIViewController {
    
    private let viewModel: HomeNewDressViewModel
    public weak var delegate: HomeNewDressViewModelDelegate?
    
    private var oldImage: UIImage?
    
    private let imageView = CustomImageView(frame: .zero)
    private let typeLabel = TitleLabel(textAlignment: .natural, fontSize: 22)
    private let magicButton = CustomButton(backgroundColor: .black, icon: "pencil", title: "Magic")
    private let backButton = CustomButton(backgroundColor: .black, icon: "arrowshape.turn.up.backward", title: "")
    
    private lazy var typeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0)
        collectionView.register(DressTypeCell.self, forCellWithReuseIdentifier: DressTypeCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(viewModel: HomeNewDressViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        let path = ImagePath.shared.getDocumentDirectory().appendingPathComponent(viewModel.dress.imagePath)
        imageView.image = UIImage(contentsOfFile: path.path)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(didTapAddButton))
        
        title = "New Clothes"
        layoutUI()
        setUpButtons()
    }
    
    private func layoutUI(){
        
        let padding: CGFloat = 20
        
        typeLabel.text = "Type"
        
        view.addSubviews(imageView, magicButton, backButton, typeLabel, typeCollectionView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            magicButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.68),
            backButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            
             //Set buttons to be in the same row
            magicButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            magicButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            magicButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            backButton.topAnchor.constraint(equalTo: magicButton.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: magicButton.bottomAnchor),
            
            typeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            typeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            typeLabel.heightAnchor.constraint(equalToConstant: 50),
            
            typeCollectionView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 5),
            typeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            typeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            typeCollectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    // MARK: Set Up Button
    
    private func setUpButtons() {
        magicButton.addTarget(self, action: #selector(didTapMagicButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.isEnabled = false
    }
    
    @objc
    private func didTapAddButton() {
        
        let imageName = UUID().uuidString
        let imagePath = ImagePath.shared.getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = imageView.image?.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        viewModel.dress.imagePath = imageName
        print(viewModel.selectedType)
        viewModel.saveData(title: "", imagePath: viewModel.dress.imagePath, type: viewModel.selectedType)
        delegate?.didAddNewDress()
        didTapCancelButton()
    }
    
    @objc
    private func didTapCancelButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    private func didTapMagicButton() {
        oldImage = imageView.image
        imageView.image = imageView.image?.removeBackground(returnResult: .finalImage)
        backButton.isEnabled = true
        magicButton.isEnabled = false
    }
    
    @objc
    private func didTapBackButton() {
        imageView.image = oldImage
        backButton.isEnabled = false
        magicButton.isEnabled = true
    }
}

extension HomeNewDressVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pickerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DressTypeCell.identifier, for: indexPath) as? DressTypeCell else { fatalError() }
        cell.configure(with: viewModel.pickerData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = viewModel.pickerDataTitle[indexPath.row]
        if type == ClothesType.jacket.title {
            viewModel.selectedType = ClothesType.jacket
        } else  if type == ClothesType.shirt.title {
            viewModel.selectedType = ClothesType.shirt
        } else  if type == ClothesType.pants.title {
            viewModel.selectedType = ClothesType.pants
        } else  if type == ClothesType.shoes.title {
            viewModel.selectedType = ClothesType.shoes
        } else  if type == ClothesType.extras.title {
            viewModel.selectedType = ClothesType.extras
        }
        print(type)
    }
    
    
}
