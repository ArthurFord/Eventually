//
//  SettingsTableViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 1/4/20.
//  Copyright © 2020 Arthur Ford. All rights reserved.
//

import UIKit



class SettingsTableViewController: UITableViewController {
    
    
    @IBOutlet var textLabels: [UILabel]!
    
    @IBOutlet var contentViews: [UIView]!
    
    
    var theme = ThemeManager.currentTheme() {
        didSet {
            navigationController?.navigationBar.backgroundColor = ThemeManager.currentTheme().backgroundColor
            navigationController?.navigationBar.tintColor = ThemeManager.currentTheme().topTextColor
            navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().backgroundColor
            let textAttributes = [NSAttributedString.Key.foregroundColor: theme.topTextColor]
            navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            view.backgroundColor = ThemeManager.currentTheme().backgroundColor
            tableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
            for label in textLabels {
                label.textColor = ThemeManager.currentTheme().topTextColor
            }
            for view in contentViews {
                view.backgroundColor = ThemeManager.currentTheme().cellBackgroundColor
            }
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        for label in textLabels {
            label.textColor = ThemeManager.currentTheme().topTextColor
        }
        for view in contentViews {
            view.backgroundColor = ThemeManager.currentTheme().cellBackgroundColor
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch tableView.cellForRow(at: indexPath)?.reuseIdentifier {
            case K.ThemeNames.blackAndWhiteTheme:
                ThemeManager.applyTheme(theme: .blackAndWhite)
                theme = ThemeManager.currentTheme()
            case K.ThemeNames.beachTheme:
                ThemeManager.applyTheme(theme: .beach)
                theme = ThemeManager.currentTheme()
            case K.ThemeNames.cuteGamerTheme:
                ThemeManager.applyTheme(theme: .cuteGamer)
                theme = ThemeManager.currentTheme()
            case K.ThemeNames.natureTheme:
                ThemeManager.applyTheme(theme: .nature)
                theme = ThemeManager.currentTheme()
            default:
                print("default")
            }
        }
        
    }
    
}
