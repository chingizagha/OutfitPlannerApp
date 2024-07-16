//
//  SettingsOption.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 07.07.24.
//

import UIKit

enum SettingsOption: CaseIterable{
    case rateApp
    case contactUs
    case privacy
    case terms
    case apiReference
    case viewCode
    
    var targetURL :URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://google.com")
        case .privacy:
            return URL(string: "https://google.com")
        case .terms:
            return URL(string: "https://google.com")
        case .apiReference:
            return URL(string: "http://rickandmortyapi.com")
        case .viewCode:
            return URL(string: "https://github.com/chingizagha/RickAndMortyAppUIKit")
        }
    }
    
    var displayTitle: String{
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .privacy:
            return "Privacy Policy"
        case .terms:
            return "Terms of Service"
        case .apiReference:
            return "API Reference"
        case .viewCode:
            return "View App Code"
        }
    }
    
    var iconContainerColor: UIColor{
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .privacy:
            return .systemYellow
        case .terms:
            return .systemRed
        case .apiReference:
            return .systemCyan
        case .viewCode:
            return .systemGray
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .privacy:
            return UIImage(systemName: "doc")
        case .terms:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
}
