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
        setUp()
    }
    
    private func setUp() {
        let clothesVC = HomeVC()
        let outfitsVC = OutfitVC()
        
        clothesVC.navigationItem.largeTitleDisplayMode = .automatic
        outfitsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: clothesVC)
        let nav2 = UINavigationController(rootViewController: outfitsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Clothes", image: UIImage(systemName: "hanger"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Outfits", image: UIImage(systemName: "pedal.clutch.fill"), tag: 2)
        
        for nav in [nav1, nav2] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2], animated: true)
    }
}
