//
//  UIViewController+Ext.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 30.06.24.
//

import UIKit

extension UIViewController {
    
    func showEmptyStateView(with message: String, in view: UIView){
        let emptyStateView = EmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubviews(emptyStateView)
    }
}
