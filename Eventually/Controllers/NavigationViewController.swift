//
//  NavigationViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 1/5/20.
//  Copyright © 2020 Arthur Ford. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ThemeManager.currentTheme().statusBarStyle
    }
    
    var theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.navigationBar.tintColor = ThemeManager.currentTheme().topTextColor
        self.navigationBar.barTintColor = ThemeManager.currentTheme().backgroundColor
        let textAttributes = [NSAttributedString.Key.foregroundColor: theme.topTextColor]
        self.navigationBar.largeTitleTextAttributes = textAttributes
        self.navigationBar.titleTextAttributes = textAttributes
        setNeedsStatusBarAppearanceUpdate()
        
    }
}
