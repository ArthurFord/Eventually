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
    @IBOutlet weak var notesTextView: UITextView!
    
    
    
    var event: Event?
    var eventIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let eventToLoad = event {
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
            dateLabel.text = dateFormatter.string(from: eventToLoad.end!)
            navigationController?.title = eventToLoad.name
            daysRemainingLabel.text = String(eventToLoad.end!.daysToEvent.day!)
            notesTextView.text = eventToLoad.notes
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesBegan(touches, with: event)
           view.endEditing(true)
       }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(identifier: K.VcId.editEventVC) as? EditEventViewController {
            vc.newEvent = event!
            vc.eventIndex = eventIndex
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    

}
