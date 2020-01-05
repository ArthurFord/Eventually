//
//  DetailViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/15/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysRemainingLabel: UILabel!
    @IBOutlet weak var reminderDateLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var dayRemainingTextLabel: UILabel!
    @IBOutlet weak var notesHeaderLabel: UILabel!
    
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let eventToLoad = event {
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
            dateLabel.text = dateFormatter.string(from: eventToLoad.end)
            navigationController?.title = eventToLoad.name
            daysRemainingLabel.text = String(eventToLoad.end.daysToEvent.day!)
            notesLabel.text = eventToLoad.notes
            if eventToLoad.reminder != nil {
                let reminderDateFormatter = DateFormatter()
                reminderDateFormatter.setLocalizedDateFormatFromTemplate(K.dateAndTime)
                reminderDateLabel.text = reminderDateFormatter.string(from: eventToLoad.reminder!)
            } else {
                reminderDateLabel.text = "No reminder set"
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        dateLabel.textColor = ThemeManager.currentTheme().bottomTextColor
        daysRemainingLabel.textColor = ThemeManager.currentTheme().topTextColor
        reminderLabel.textColor = ThemeManager.currentTheme().topTextColor
        daysRemainingLabel.textColor = ThemeManager.currentTheme().bottomTextColor
        reminderDateLabel.textColor = ThemeManager.currentTheme().bottomTextColor
        dayRemainingTextLabel.textColor = ThemeManager.currentTheme().topTextColor
        notesHeaderLabel.textColor = ThemeManager.currentTheme().topTextColor
        notesLabel.textColor = ThemeManager.currentTheme().bottomTextColor
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesBegan(touches, with: event)
           view.endEditing(true)
       }
    

    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(identifier: K.VcId.editEventViewControllerID) as? EditEventViewController {
            vc.originalEvent = event! 
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    

}
