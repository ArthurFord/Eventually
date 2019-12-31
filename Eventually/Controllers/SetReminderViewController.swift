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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let eventToLoad = event {
            datePickerView.setDate(eventToLoad.end, animated: true)
            datePickerView.maximumDate = eventToLoad.end
        }
        datePickerView.minimumDate = Date()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.unwindToNewEventFromReminderID {
            if segue.destination is NewEventViewController {
                let vc = segue.destination as! NewEventViewController
                
                vc.newEvent.reminder = datePickerView.date
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate(K.dateAndTime)
                vc.reminderLabel.text = dateFormatter.string(from: datePickerView.date)
                vc.reminderSwitch.isOn = true
            }
        }
    }
    
    
    
}
