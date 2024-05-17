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
    
    private let imageView = CustomImageView(frame: .zero)
    private let addButton = CustomButton(backgroundColor: .blue, title: "Add")
    private let typeButton = CustomButton(backgroundColor: .red, title: "Type")
    private let magicButton = CustomButton(backgroundColor: .green, title: "Magic")
    private let backButton = CustomButton(backgroundColor: .yellow, title: "Back")
    
    private lazy var pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.isHidden = true
        pv.delegate = self
        pv.dataSource = self
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
//    private let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .equalSpacing
//        stackView.alignment = .center
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.layer.cornerRadius = 10
//        return stackView
//    }()
    
    init(viewModel: HomeNewDressViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        let path = ImagePath.shared.getDocumentDirectory().appendingPathComponent(viewModel.dress.imagePath)
        imageView.image = UIImage(contentsOfFile: path.path)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    init(dress: Dress) {
//        self.dress = dress
//        super.init(nibName: nil, bundle: nil)
//        let path = ImagePath.shared.getDocumentDirectory().appendingPathComponent(dress.imagePath)
//        imageView.image = UIImage(contentsOfFile: path.path)
//    }
    
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
            
//            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
//            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
//            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
//            stackView.heightAnchor.constraint(equalToConstant: 100),
            
            typeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            typeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            typeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            typeButton.heightAnchor.constraint(equalToConstant: 50),
            
            magicButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.68),
            // Set button2 width to be 20% of the view's width
            backButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            
            // Set buttons to be in the same row
            magicButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            magicButton.topAnchor.constraint(equalTo: typeButton.bottomAnchor, constant: 20),
            magicButton.heightAnchor.constraint(equalToConstant: 50),
            //backButton.leadingAnchor.constraint(equalTo: magicButton.trailingAnchor, constant: padding),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            backButton.topAnchor.constraint(equalTo: magicButton.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: magicButton.bottomAnchor),
            
            addButton.topAnchor.constraint(equalTo: magicButton.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
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
    }
    
    @objc
    private func didTapAddButton() {
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
        imageView.image = imageView.image?.removeBackground(returnResult: .background)
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
