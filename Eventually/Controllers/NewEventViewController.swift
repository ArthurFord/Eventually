//
//  NewEventViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/15/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit
import Firebase

class NewEventViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    
    var newEvent = Event()
    
    let db = Firestore.firestore()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func nameTextFieldDidEndEditing(_ sender: UITextField) {
        newEvent.name = nameTextField.text ?? ""
        
    }
    
    @IBAction func endDatePickerValueChanged(_ sender: UIDatePicker) {
        let fullDate = endDatePicker.date
        let fullDateAtNoon = calendar.date(bySetting: .hour, value: 12, of: fullDate)
        newEvent.end = fullDateAtNoon!

        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.unwindToRootID {
            if segue.destination is MasterViewController {
                newEvent.notes = notesTextView.text ?? ""
                newEvent.name = nameTextField.text ?? ""
                let startTimestamp = Timestamp(date: newEvent.start)
                let endTimestamp = Timestamp(date: newEvent.end)
                newEvent.userId = Auth.auth().currentUser!.uid
                print(newEvent.userId)
                db.collection(K.FStore.collectionName).document("\(newEvent.userId)\(newEvent.name)").setData([
                    K.FStore.name:newEvent.name,
                    K.FStore.start:startTimestamp,
                    K.FStore.end:endTimestamp,
                    K.FStore.notes:newEvent.notes,
                    K.FStore.userId:newEvent.userId
                ]) { (error) in
                    if let err = error {
                        print("FireStore \(err)")
                    } else {
                        print("successfully saved data")
                    }
                }
            }
        }
    }
}
