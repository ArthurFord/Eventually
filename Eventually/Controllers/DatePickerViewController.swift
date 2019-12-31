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
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let eventToLoad = event {
            datePicker.setDate(eventToLoad.end, animated: true)
        }
        datePicker.minimumDate = Date()
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.unwindSetDateToNewViewID {
            if segue.destination is NewEventViewController {
                let vc = segue.destination as! NewEventViewController
                
                vc.newEvent.end = Calendar.current.startOfDay(for: datePicker.date)
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
                vc.datelabel.text = dateFormatter.string(from: datePicker.date)
            }
        }
    }

    
    
    
}
