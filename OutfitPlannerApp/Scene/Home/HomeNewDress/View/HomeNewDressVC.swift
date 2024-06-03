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
    private let addButton = CustomButton(backgroundColor: .systemBlue, title: "Add")
    private let typeButton = CustomButton(backgroundColor: .systemGray, title: "Type")
    private let magicButton = CustomButton(backgroundColor: .systemGray, icon: "pencil", title: "Magic")
    private let backButton = CustomButton(backgroundColor: .systemGray, icon: "arrowshape.turn.up.backward", title: "")
    
    private lazy var pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.isHidden = true
        pv.delegate = self
        pv.dataSource = self
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
        
        title = "New Clothes"
        layoutUI()
        setUpButtons()
    }
    
    private func layoutUI(){
        
        let padding: CGFloat = 20
        
        
        view.addSubviews(imageView, typeButton, addButton, pickerView, magicButton, backButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            typeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            typeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            typeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            typeButton.heightAnchor.constraint(equalToConstant: 50),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
            magicButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.68),
            backButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            
            // Set buttons to be in the same row
            magicButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            magicButton.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20),
            magicButton.heightAnchor.constraint(equalToConstant: 50),
            //backButton.leadingAnchor.constraint(equalTo: magicButton.trailingAnchor, constant: padding),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            backButton.topAnchor.constraint(equalTo: magicButton.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: magicButton.bottomAnchor),
            
            
            
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Set Up Button
    
    private func setUpButtons() {
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        typeButton.addTarget(self, action: #selector(didTapTypeButton), for: .touchUpInside)
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
        
        viewModel.saveData(title: "", imagePath: viewModel.dress.imagePath, type: viewModel.selectedType)
        delegate?.didAddNewDress()
        dismiss(animated: true)
    }
    
    @objc
    private func screenTapped() {
        if !pickerView.isHidden {
            pickerView.isHidden = true
            typeButton.setTitle(viewModel.selectedType.title, for: .normal)
        }
    }
    
    @objc
    private func didTapTypeButton() {
        pickerView.isHidden = false
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

extension HomeNewDressVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.pickerData.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //selectedType = PickerOptions(rawValue: pickerData[row])
        viewModel.selectedType = ClothesType(rawValue: viewModel.pickerData.firstIndex(of: viewModel.pickerData[row])!)!
    }
}
