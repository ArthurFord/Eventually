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
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var endDateView: UIView!
    
    
    var newEvent = Event()
    
    let db = Firestore.firestore()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
        datelabel.text = dateFormatter.string(from: newEvent.end)
        reminderSwitch.isOn = newEvent.reminderOn
        
        reminderView.layer.cornerRadius = reminderView.frame.height / 4
        endDateView.layer.cornerRadius = endDateView.frame.height / 4
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func nameTextFieldDidEndEditing(_ sender: UITextField) {
        newEvent.name = nameTextField.text ?? ""
        
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
           
       }
    
    @IBAction func ReminderSwitchChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            newEvent.reminderOn = true
                    if let vc = storyboard?.instantiateViewController(identifier: K.VcId.setReminderViewControllerID) as? SetReminderViewController {
                       vc.event = newEvent
                       navigationController?.pushViewController(vc, animated: true)
                   }
        } else {
            newEvent.reminderOn = false
            newEvent.reminder = nil
            reminderLabel.text = "Set Reminder"
        }
    }
    
    
    @IBAction func setDateButtonTapped(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(identifier: K.VcId.datePickerViewControllerID) as? DatePickerViewController {
            vc.event = newEvent
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func setReminderButtonTapped(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(identifier: K.VcId.setReminderViewControllerID) as? SetReminderViewController {
                   vc.event = newEvent
                   navigationController?.pushViewController(vc, animated: true)
               }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.unwindToRootID {
            if segue.destination is MasterViewController {
                newEvent.notes = notesTextField.text ?? ""
                newEvent.name = nameTextField.text ?? ""
                let startTimestamp = Timestamp(date: newEvent.start)
                let endTimestamp = Timestamp(date: newEvent.end)
                newEvent.userId = Auth.auth().currentUser!.uid
                
                db.collection(K.FStore.collectionName).document("\(newEvent.userId)\(newEvent.name)").setData([
                    K.FStore.name:newEvent.name,
                    K.FStore.start:startTimestamp,
                    K.FStore.end:endTimestamp,
                    K.FStore.notes:newEvent.notes,
                    K.FStore.userId:newEvent.userId,
                    K.FStore.reminder:newEvent.reminder ?? ""
                ]) { (error) in
                    if let err = error {
                        print("FireStore \(err)")
                    } else {
                        print("successfully saved data")
                    }
                }
            }
        }
        if newEvent.reminderOn, newEvent.reminder != nil {
            print("reminder seq started.")
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
            
            let content = UNMutableNotificationContent()
            content.title = newEvent.name
            content.body = dateFormatter.string(from: newEvent.end)
            
            let components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: newEvent.reminder!)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: newEvent.name, content: content, trigger: trigger)
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
               if error != nil {
                print(error?.localizedDescription ?? "")
               } else {
                print("saved notification")
                }
            }
        }
        
    }
}
