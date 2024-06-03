//
//  HomeVC.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 10.05.24.
//

import UIKit
import RealmSwift

class HomeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let viewModel = HomeViewModel()
    
    private var isSegmentModeOn = false
    private var titleArray = [String]()
    
    private let segmentedController: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var segmentedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0)
        collectionView.register(SegmentedCell.self, forCellWithReuseIdentifier: SegmentedCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the gradient layer frame to match the view's bounds
        gradientLayer.frame = view.bounds
    }

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Dress>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Clothes"
        
         //Find url for Realm database
//        let realm = try! Realm()
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        view.backgroundColor = .systemPink
        
        navigationItem.rightBarButtonItem = setUpDropDown()
        
        gradientLayer.frame = view.bounds
        
        // Add the gradient layer to the view's layer
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        addGradientBackground()
        
        getClothes()
        configureCollectionView()
        setupSegmentedControl()
        configureDataSource()
        layoutUI()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Check if the user interface style has changed
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            addGradientBackground()
        }
    }

    func addGradientBackground() {
        
        if traitCollection.userInterfaceStyle == .dark {
            // Colors for dark mode
            gradientLayer.colors = [
                UIColor.secondarySystemBackground.cgColor,
                UIColor.systemGreen.cgColor
            ]
            print("dark")
        } else {
            // Colors for light mode
            gradientLayer.colors = [
                UIColor.systemBackground.cgColor,
                UIColor.green.cgColor
            ]
            print("else")
        }
        
        // Optionally set the locations of the colors
        gradientLayer.locations = [0.0, 1.0]
        
        // Optionally set the start and end points of the gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    private func getClothes() {
        viewModel.fetchData()
        segmentedController.selectedSegmentIndex = UISegmentedControl.noSegment
        self.updateData(on: viewModel.dressArray)
    }
    
    // MARK: Segmented Controller
    
    private func setupSegmentedControl() {
        for segment in ClothesType.allCases {
            titleArray.append(segment.title)
            segmentedController.insertSegment(withTitle: segment.title, at: segment.rawValue, animated: true)
        }
        
        segmentedController.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        if let selectedSegment = ClothesType(rawValue: sender.selectedSegmentIndex) {
            isSegmentModeOn = true
            viewModel.filterDress(selectedSegment)
            self.updateData(on: viewModel.filteredDressArray)
        }
    }
    
    // MARK: Button Functions
    
    private func didTapAddPhotoButton(_ sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = ImagePath.shared.getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let allCases: [ClothesType] = [.jeans, .tshirt, .jacket]
        
        let dress = Dress()
        dress.imagePath = imageName
        dress.type = allCases.randomElement()!
        
        
        let vm = HomeNewDressViewModel(dress: dress)
        let vc = HomeNewDressVC(viewModel: vm)
        vc.delegate = self
        
        picker.dismiss(animated: true)
        present(vc, animated: true)
    }
    
    private func setUpDropDown() -> UIBarButtonItem{
        let button = UIButton(type: .system)
        button.setImage(.add, for: .normal)
        
        var menuChildren: [UIMenuElement] = []
        
        menuChildren.append(UIAction(title: "Take Photo", image: UIImage(systemName: "camera"), handler: { [weak self] _ in
            self?.didTapAddPhotoButton(.camera)
        }))
        
        menuChildren.append(UIAction(title: "Choose Photo", image: UIImage(systemName: "photo.stack"), handler: { [weak self] _ in
            self?.didTapAddPhotoButton(.photoLibrary)
        }))
        
        button.menu = UIMenu(options: .displayInline, children: menuChildren)
        
        button.showsMenuAsPrimaryAction = true
        return UIBarButtonItem(customView: button)
    }
    
    // MARK: Layout Section
    
    private func layoutUI(){
        
        scrollView.addSubview(contentView)
        contentView.addSubviews(segmentedCollectionView, collectionView)
        view.addSubviews(scrollView)
        
        let hConst = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        hConst.isActive = true
        hConst.priority = UILayoutPriority(50)
        
        
        NSLayoutConstraint.activate([
                        
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            segmentedCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            segmentedCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            segmentedCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            segmentedCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: segmentedCollectionView.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: CollectionView Set Up
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        //collectionView.alwaysBounceVertical = true
        collectionView.register(DressCell.self, forCellWithReuseIdentifier: DressCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Dress>(collectionView: collectionView, cellProvider: { collectionView, indexPath, dress in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DressCell.identifier, for: indexPath) as! DressCell
            cell.configure(dress: dress)
            return cell
        })
    }
    
    private func updateData(on dress: [Dress]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Dress>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dress)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func createFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 20
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return layout
    }
}

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Remove", image: .remove) {  _ in
                    guard let self else {return}
                    let dress = (self.isSegmentModeOn ? self.viewModel.filteredDressArray : self.viewModel.dressArray)[indexPath.row]
                    
                    self.viewModel.deleteData(dress: dress)
                    self.getClothes()
                }
                return UIMenu(children: [downloadAction])
            }
        return config
    }
}

extension HomeVC: HomeNewDressViewModelDelegate {
    
    func didAddNewDress() {
        getClothes()
    }
    
    
}

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.segmentedCollectionView {
            return ClothesType.allCases.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.segmentedCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentedCell.identifier, for: indexPath) as? SegmentedCell else {fatalError()}
            cell.configure(title: titleArray[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.segmentedCollectionView {
            print(indexPath.row)
            if let selectedSegment = ClothesType(rawValue: indexPath.item) {
                isSegmentModeOn = true
                viewModel.filterDress(selectedSegment)
                self.updateData(on: viewModel.filteredDressArray)
            }
        }
    }
}






