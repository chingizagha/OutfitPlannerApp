//
//  UIView+Ext.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 10.05.24.
//

import UIKit

extension UIView{
    
    func addSubviews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}
