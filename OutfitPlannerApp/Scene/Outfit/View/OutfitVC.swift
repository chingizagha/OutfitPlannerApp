//
//  OutfitVC.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 10.05.24.
//

import UIKit

class OutfitVC: UIViewController {
    
    let viewModel = OutfitViewModel()
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Dress>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Outfits"
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = setUpDropDown()
    }
    
    private func setUpDropDown() -> UIBarButtonItem{
        let button = UIButton(type: .system)
        button.setImage(.add, for: .normal)
        
        var menuChildren: [UIMenuElement] = []
        
        menuChildren.append(UIAction(title: "Create Outfit", image: UIImage(systemName: "hanger"), handler: { [weak self] _ in
            let vc = OutfitSelectVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }))
        
        button.menu = UIMenu(options: .displayInline, children: menuChildren)
        
        button.showsMenuAsPrimaryAction = true
        return UIBarButtonItem(customView: button)
    }
    
    // MARK: Layout Section
    
    private func layoutUI(){
        
        view.addSubviews(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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

extension OutfitVC: UICollectionViewDelegate {
    
}
