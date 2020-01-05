//
//  EditEventViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 1/5/20.
//  Copyright © 2020 Arthur Ford. All rights reserved.
//

import UIKit
import Firebase

class EditEventViewController: UITableViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet var tableCellsCollection: [UITableViewCell]!
    
    @IBOutlet var tableLabels: [UILabel]!
    
    
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var setDateLabel: UILabel!
    @IBOutlet weak var setReminderLabel: UILabel!
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    var newEvent = Event()
    var originalEvent: Event?
    
    let db = Firestore.firestore()
    let calendar = Calendar.current
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let eventToLoad = originalEvent {
            
            //load the original event
            newEvent.name = originalEvent?.name ?? ""
            newEvent.end = originalEvent?.end ?? Date()
            newEvent.notes = originalEvent?.notes ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
            setDateLabel.text = dateFormatter.string(from: eventToLoad.end)
            reminderSwitch.isOn = eventToLoad.reminderOn
            titleTextField.text = eventToLoad.name
            notesTextField.text = eventToLoad.notes
            let reminderDateFormatter = DateFormatter()
            reminderDateFormatter.setLocalizedDateFormatFromTemplate(K.dateAndTime)
            
            if eventToLoad.reminder != nil {
                setReminderLabel.text = reminderDateFormatter.string(from: eventToLoad.reminder!)
            }
        } else {
            //load from new event
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
            setDateLabel.text = dateFormatter.string(from: newEvent.end)
            reminderSwitch.isOn = newEvent.reminderOn
            titleTextField.text = newEvent.name
            notesTextField.text = newEvent.notes
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if setReminderLabel.text == "Set Reminder" {
            reminderSwitch.isOn = false
        }
        
        view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        tableView.sectionIndexBackgroundColor = ThemeManager.currentTheme().backgroundColor
        for cell in tableCellsCollection {
            cell.backgroundColor = ThemeManager.currentTheme().cellBackgroundColor
        }
        for label in tableLabels {
            label.textColor = ThemeManager.currentTheme().topTextColor
        }
        reminderSwitch.onTintColor = ThemeManager.currentTheme().topTextColor
        titleTextField.backgroundColor = ThemeManager.currentTheme().cellBackgroundColor
        titleTextField.textColor = ThemeManager.currentTheme().topTextColor
        titleTextField.tintColor = ThemeManager.currentTheme().bottomTextColor
        notesTextField.backgroundColor = ThemeManager.currentTheme().cellBackgroundColor
        notesTextField.textColor = ThemeManager.currentTheme().topTextColor
        let titleAttributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().bottomTextColor])
        titleTextField.attributedPlaceholder = titleAttributedPlaceholder
        let notesAttributedPlaceholder = NSAttributedString(string: "Notes", attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().bottomTextColor])
        notesTextField.attributedPlaceholder = notesAttributedPlaceholder
    }
    
    
    
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        if sender.isOn == false {
            newEvent.reminderOn = false
            newEvent.reminder = nil
            setReminderLabel.text = "Set Reminder"
            
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [newEvent.name])
            
        } else {
            setReminder()
        }
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [1,0] {
            if let vc = storyboard?.instantiateViewController(identifier: K.VcId.datePickerViewControllerID) as? DatePickerViewController {
                vc.event = newEvent
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath == [1,1] {
            setReminder()
        }
        if indexPath == [1,2] {
            setReminder()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setReminder() {
        newEvent.reminderOn = true
        
        if let vc = storyboard?.instantiateViewController(identifier: K.VcId.setReminderViewControllerID) as? SetReminderViewController {
            vc.event = newEvent
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification){

        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        tableView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInset
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.unwindToRootID {
            if segue.destination is MasterViewController {
                newEvent.notes = notesTextField.text ?? ""
                newEvent.name = titleTextField.text ?? ""
                let startTimestamp = Timestamp(date: newEvent.start)
                let endTimestamp = Timestamp(date: newEvent.end)
                newEvent.userId = Auth.auth().currentUser!.uid
                
                if originalEvent != nil {
                    //delete original event
                    db.collection(K.FStore.collectionName).document("\(Auth.auth().currentUser!.uid)\(originalEvent!.name)").delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("deleted Data")
                        }
                    }
                    notificationCenter.removePendingNotificationRequests(withIdentifiers: [originalEvent!.name])
                }
                
                db.collection(K.FStore.collectionName).document("\(newEvent.userId)\(newEvent.name)").setData([
                    K.FStore.name:newEvent.name,
                    K.FStore.start:startTimestamp,
                    K.FStore.end:endTimestamp,
                    K.FStore.notes:newEvent.notes,
                    K.FStore.userId:newEvent.userId,
                    K.FStore.reminder:newEvent.reminder,
                    K.FStore.reminderOn:newEvent.reminderOn
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
            
            let content = UNMutableNotificationContent()
            content.title = newEvent.name
            content.body = dateFormatter.string(from: newEvent.end)
            
            let components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: newEvent.reminder!)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: newEvent.name, content: content, trigger: trigger)
            
            
            notificationCenter.add(request) { (error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                } else {
                    print("saved notification")
                }
            }
        }
        if !newEvent.reminderOn {
            
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [newEvent.name])
        }
        
    }
    
    
    
}
