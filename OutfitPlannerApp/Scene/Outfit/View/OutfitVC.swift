//
//  OutfitVC.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 10.05.24.
//

import UIKit

enum Section {
    case main
}

class OutfitVC: UIViewController {
    
    let viewModel = OutfitViewModel()
    let emptyStateView = EmptyStateView(message: "No Outfits?\nAdd one the outfits screen.")
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Outfit>!
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the gradient layer frame to match the view's bounds
        gradientLayer.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Outfits"
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = setUpDropDown()
        
        gradientLayer.frame = view.bounds
        
        // Add the gradient layer to the view's layer
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        emptyStateView.isHidden = true
        
        addGradientBackground()
        
        
        configureCollectionView()
        configureDataSource()
        layoutUI()
        getOutfits()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("outfitAdded"), object: nil, queue: nil) { _ in
            self.getOutfits()
        }
        
        
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
        } else {
            // Colors for light mode
            gradientLayer.colors = [
                UIColor.systemBackground.cgColor,
                UIColor.green.cgColor
            ]
        }
        
        // Optionally set the locations of the colors
        gradientLayer.locations = [0.0, 1.0]
        
        // Optionally set the start and end points of the gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    private func setUpDropDown() -> UIBarButtonItem{
        let button = UIButton(type: .system)
        button.setImage(.add, for: .normal)
        
        var menuChildren: [UIMenuElement] = []
        
        menuChildren.append(UIAction(title: "Create Outfit", image: UIImage(systemName: "hanger"), handler: { [weak self] _ in
            let vc = OutfitSelectVC()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }))
        
        button.menu = UIMenu(options: .displayInline, children: menuChildren)
        
        button.showsMenuAsPrimaryAction = true
        return UIBarButtonItem(customView: button)
    }
    
    // MARK: Layout Section
    
    private func layoutUI(){
        
        view.addSubviews(collectionView, emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            emptyStateView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: Data Function
    
    private func getOutfits() {
        viewModel.fetchData()
        self.updateData(on: viewModel.outfitArray)
    }
    
    // MARK: CollectionView Set Up
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(OutfitCell.self, forCellWithReuseIdentifier: OutfitCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Outfit>(collectionView: collectionView, cellProvider: { collectionView, indexPath, outfit in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OutfitCell.identifier, for: indexPath) as! OutfitCell
            cell.configure(outfit: outfit)
            return cell
        })
    }
    
    private func updateData(on outfit: [Outfit]) {
        if outfit.isEmpty {
            emptyStateView.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyStateView.isHidden = true
            collectionView.isHidden = false
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Outfit>()
        snapshot.appendSections([.main])
        snapshot.appendItems(outfit)
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
        let itemWidth = availableWidth / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return layout
    }
}
extension OutfitVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Remove", image: .remove) {  _ in
                    guard let self else {return}
                    let outfit = self.viewModel.outfitArray[indexPath.row]
                    
                    self.viewModel.deleteData(outfit: outfit)
                    self.getOutfits()
                }
                return UIMenu(children: [downloadAction])
            }
        return config
    }
}

