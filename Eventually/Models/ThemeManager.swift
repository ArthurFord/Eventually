//
//  ThemeManager.swift
//  Eventually
//
//  Created by Arthur Ford on 1/5/20.
//  Copyright © 2020 Arthur Ford. All rights reserved.
//

import Foundation
import UIKit

enum Theme: Int {
    case blackAndWhite
    case beach
    case cuteGamer
    case nature
    
    var backgroundColor: UIColor {
        switch self {
        case .blackAndWhite:
            return .systemBackground
        case .beach:
            return UIColor(named: K.Colors.Beach.beachBackground)!
        case .cuteGamer:
            return UIColor(named: K.Colors.CuteGamer.cuteGamerBackground)!
        case .nature:
            return UIColor(named: K.Colors.Natural.naturalBackground)!
        }
    }
    var cellBackgroundColor: UIColor {
        switch self {
        case .blackAndWhite:
            return UIColor(named: K.Colors.BlackAndWhite.defaultCellBackground)!
        case .beach:
            return UIColor(named: K.Colors.Beach.beachCellBackground)!
        case .cuteGamer:
            return UIColor(named: K.Colors.CuteGamer.cuteGamerCellBackground)!
        case .nature:
            return UIColor(named: K.Colors.Natural.naturalCellBackground)!
        }
    }
    var topTextColor: UIColor {
        switch self {
        case .blackAndWhite:
            return UIColor.label
        case .beach:
            return UIColor(named: K.Colors.Beach.beachTopText)!
        case .cuteGamer:
            return UIColor(named: K.Colors.CuteGamer.cuteGamerTopText)!
        case .nature:
            return UIColor(named: K.Colors.Natural.naturalTopText)!
        }
    }
    var bottomTextColor: UIColor {
        switch self {
        case .blackAndWhite:
            return UIColor.label
        case .beach:
            return UIColor(named: K.Colors.Beach.beachBottomText)!
        case .cuteGamer:
            return UIColor(named: K.Colors.CuteGamer.cuteGamerBottomText)!
        case .nature:
            return UIColor(named: K.Colors.Natural.naturalBottomText)!
        }
    }
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .blackAndWhite:
            return .default
        case .beach:
            return .darkContent
        case .cuteGamer:
            return .lightContent
        case .nature:
            return .lightContent
        }
    }
}

let selectedThemeKey = "selectedThemeKey"

struct ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: selectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .blackAndWhite
        }
    }
    
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: selectedThemeKey)
        UserDefaults.standard.synchronize()
        
    }
}
