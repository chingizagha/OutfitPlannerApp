//
//  TabBarVC.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 10.05.24.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.tintColor = .black
        setUp()
    }
    
    private func setUp() {
        let clothesVC = HomeVC()
        let outfitsVC = OutfitVC()
        
        clothesVC.navigationItem.largeTitleDisplayMode = .always
        outfitsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: clothesVC)
        let nav2 = UINavigationController(rootViewController: outfitsVC) 
        
        nav1.tabBarItem = UITabBarItem(title: "Clothes", image: UIImage(systemName: "figure.stand"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Outfits", image: UIImage(systemName: "figure.2.and.child.holdinghands"), tag: 2)
        
        for nav in [nav1, nav2] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2], animated: true)
    }
}
