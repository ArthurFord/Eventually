//
//  SetReminderViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/26/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit

class SetReminderViewController: UIViewController {
    
    var event: Event?
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var setReminderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let eventToLoad = event {
            if eventToLoad.reminder != nil{
                datePickerView.setDate(eventToLoad.reminder!, animated: false)
            } else {
                datePickerView.setDate(eventToLoad.end, animated: false)
            }
            
            datePickerView.maximumDate = eventToLoad.end
        }
        datePickerView.minimumDate = Date()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        datePickerView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        datePickerView.tintColor = ThemeManager.currentTheme().topTextColor
        datePickerView.setValue(ThemeManager.currentTheme().topTextColor, forKey: "textColor")
        datePickerView.setValue(false, forKey: "highlightsToday")
        setReminderLabel.textColor = ThemeManager.currentTheme().topTextColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.unwindToNewEventFromReminderID {
            if segue.destination is EditEventViewController {
                let vc = segue.destination as! EditEventViewController
                
                vc.newEvent.reminder = datePickerView.date
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate(K.dateAndTime)
                vc.setReminderLabel.text = dateFormatter.string(from: datePickerView.date)
                vc.reminderSwitch.isOn = true
            }
        }
    }
    
    
    
}
