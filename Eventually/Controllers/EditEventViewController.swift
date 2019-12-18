//
//  EditEventViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/17/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit
import Firebase

class EditEventViewController: UIViewController {
    
    var originalEvent: Event?
    var newEvent: Event?
    var eventIndex = 0
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let eventToLoad = newEvent {
            originalEvent = eventToLoad
            nameTextField.text = eventToLoad.name
            notesTextView.text = eventToLoad.notes
            datePicker.setDate(eventToLoad.end, animated: true)
            print(eventIndex)
        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        newEvent?.end = datePicker.date
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.unwindToEventsID {
            
            if segue.destination is MasterViewController {
                db.collection(K.FStore.collectionName).document("\(Auth.auth().currentUser!.uid)\(originalEvent!.name)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("deleted Data")
                    }
                }
                
                newEvent!.notes = notesTextView.text ?? ""
                newEvent!.name = nameTextField.text ?? ""
                let startTimestamp = Timestamp(date: newEvent!.start)
                let endTimestamp = Timestamp(date: newEvent!.end)
                newEvent!.userId = Auth.auth().currentUser!.uid
                
                db.collection(K.FStore.collectionName).document("\(newEvent!.userId)\(newEvent!.name)").setData([
                    K.FStore.name:newEvent!.name,
                    K.FStore.start:startTimestamp,
                    K.FStore.end:endTimestamp,
                    K.FStore.notes:newEvent!.notes,
                    K.FStore.userId:newEvent!.userId
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
