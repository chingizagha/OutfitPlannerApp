//
//  OnboardingVC.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 30.06.24.
//

import UIKit


import UIKit

struct Slide {
    let title: String
    let text: String
    let animationName: String
    
    static let collection: [Slide] = [
        .init(title: "Easy to find", text: "Find all your house needs in one place. We provide every service to make your home experience smooth", animationName: "outfitAnim01"),
        .init(title: "Easy for Transportation", text: "We provide the best transportation service and organize your furniture properly to prevent any damage", animationName: "outfitAnim02"),
    ]
}

class OnboardingVC: UIViewController {
    
    private let slides: [Slide] = Slide.collection
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .darkGray
        control.currentPageIndicatorTintColor = .black
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpPageControl()
        layoutUI()
    }
    
    private func setUpPageControl() {
        pageControl.numberOfPages = slides.count
        let angle = CGFloat.pi
        pageControl.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    private func layoutUI(){
        view.addSubviews(pageControl, collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }
    
    private func handleNextButtonTap(at indexPath: IndexPath){
        if indexPath.item == slides.count - 1{
            let vc = TabBarVC()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            let nextItem = indexPath.item + 1
            let nextIndexPath = IndexPath(item: nextItem, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .top, animated: true)
            pageControl.currentPage = nextItem
        }
    }
    
    private func handleSkipButtonTap(){
        UserDefaults.standard.set(true, forKey: "notFirstInApp")
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthentication() 
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(collectionView.contentOffset.y / scrollView.frame.size.height)
        pageControl.currentPage = index
    }
    
    
    

}

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.identifier, for: indexPath) as? OnboardingCell  else {
            fatalError()
        }
        cell.backgroundColor = .systemBackground
        let slide = slides[indexPath.row]
        cell.configure(with: slide)
        cell.nextButtonDidTap = { [weak self] in
            self?.handleNextButtonTap(at: indexPath)
        }
        cell.skipButtonDidTap = { [weak self] in
            self?.handleSkipButtonTap()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
