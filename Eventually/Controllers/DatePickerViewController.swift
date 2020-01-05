//
//  DatePickerViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/26/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    var event: Event?
    
    @IBOutlet weak var setDateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let eventToLoad = event {
            datePicker.setDate(eventToLoad.end, animated: true)
        }
        datePicker.minimumDate = Date()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        datePicker.backgroundColor = ThemeManager.currentTheme().backgroundColor
        datePicker.tintColor = ThemeManager.currentTheme().topTextColor
        datePicker.setValue(ThemeManager.currentTheme().topTextColor, forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
        setDateLabel.textColor = ThemeManager.currentTheme().topTextColor
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.unwindSetDateToNewViewID {
            if segue.destination is EditEventViewController {
                let vc = segue.destination as! EditEventViewController
                
                vc.newEvent.end = Calendar.current.startOfDay(for: datePicker.date)
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
                vc.setDateLabel.text = dateFormatter.string(from: datePicker.date)
            }
        }
    }

    
    
    
}
