//
//  HomeVC.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 10.05.24.
//

import UIKit
import RealmSwift

enum Section {
    case main
}

class HomeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let viewModel = HomeViewModel()
    
    private var isSegmentModeOn = false
    
    private let segmentedController: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Dress>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Clothes"
        
        // Find url for Realm database
//        let realm = try! Realm()
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = setUpDropDown()
        
        getClothes()
        configureCollectionView()
        setupSegmentedControl()
        configureDataSource()
        layoutUI()
        
    }
    
    private func getClothes() {
        viewModel.fetchData()
        segmentedController.selectedSegmentIndex = UISegmentedControl.noSegment
        self.updateData(on: viewModel.dressArray)
    }
    
    // MARK: Segmented Controller
    
    private func setupSegmentedControl() {
        for segment in ClothesType.allCases {
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
        
        let allCases: [ClothesType] = [.bottom, .mid, .top]
        
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
        
        view.addSubviews(segmentedController, collectionView)
        
        NSLayoutConstraint.activate([
            segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedController.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            segmentedController.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            segmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 20),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: CollectionView Set Up
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
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
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
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






