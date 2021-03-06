//
//  EventTableViewCell.swift
//  Eventually
//
//  Created by Arthur Ford on 12/15/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var daysRemainingLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    @IBOutlet weak var cellContentView: UIView!
    
    @IBOutlet weak var topContentView: UIView!
    
    
    var theme = ThemeManager.currentTheme()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //cellContentView.layer.cornerRadius = cellContentView.frame.height / 4
        applyThemeToCells()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func applyThemeToCells() {
        theme = ThemeManager.currentTheme()
        
        topContentView.backgroundColor = theme.backgroundColor
        cellContentView.backgroundColor = theme.cellBackgroundColor
        eventNameLabel.textColor = theme.topTextColor
        daysRemainingLabel.textColor = theme.topTextColor
        eventDateLabel.textColor = theme.bottomTextColor
        daysLabel.textColor = theme.bottomTextColor
    }
    
}
