//
//  MasterViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/15/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class MasterViewController: UIViewController {
    
    var arrayOfEvents = [[Event]]()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        registerTableViewCells()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadEvents()
        
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        eventsTableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        if let indexPaths = eventsTableView.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                let cell = eventsTableView.cellForRow(at: indexPath)
                cell?.awakeFromNib()
            }
        }
    }
    
    func loadEvents() {
        let calendar = Calendar.current
        let cutOffDate = calendar.date(byAdding: .day, value: -1, to: Date())!
        let cutOffDateStored = calendar.startOfDay(for: cutOffDate)
        
        db.collection(K.FStore.collectionName)
            .whereField(K.FStore.userId, isEqualTo: Auth.auth().currentUser!.uid)
            .order(by: K.FStore.end)
            .addSnapshotListener { (querySnapshot, error) in
                self.arrayOfEvents.removeAll()
                if let err = error {
                    print("error getting data \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        
                        for document in snapshotDocuments {
                            let data = document.data()
                            
                            guard let startTimeStamp = data[K.FStore.start] as? Timestamp  else { return }
                            let startDate = startTimeStamp.dateValue()
                            
                            guard let endTimeStamp = data[K.FStore.end] as? Timestamp  else { return }
                            let endDate = endTimeStamp.dateValue()
                            
                            guard let name = data[K.FStore.name] as? String else {return}
                            guard let notes = data[K.FStore.notes] as? String else {return}
                            
                            let reminderOn = data[K.FStore.reminderOn] as? Bool ?? false
                            
                            let reminderTimeStamp = data[K.FStore.reminder] as? Timestamp ?? nil
                            let reminder = reminderTimeStamp?.dateValue()
                            
                            let newEvent = Event()
                            newEvent.name = name
                            newEvent.end = endDate
                            newEvent.start = startDate
                            newEvent.notes = notes
                            newEvent.reminder = reminder
                            newEvent.reminderOn = reminderOn
                            
                            let startOfDayEndDate = calendar.startOfDay(for: newEvent.end)
                            if startOfDayEndDate > cutOffDateStored {
                                var newEventArray:[Event] = []
                                newEventArray.append(newEvent)
                                self.arrayOfEvents.append(newEventArray)
                            }
                            
                            DispatchQueue.main.async {
                                self.eventsTableView.reloadData()
                            }
                        }
                    }
                }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(identifier: K.VcId.editEventViewControllerID) as? EditEventViewController {
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(identifier: K.VcId.settingsViewControllerID) as? SettingsTableViewController {
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    
}
//MARK: - TableView Delegate

extension MasterViewController: UITableViewDelegate, UITableViewDataSource {
    func registerTableViewCells() {
        let tableViewCell = UINib(nibName: K.table.nibName, bundle: nil)
        self.eventsTableView.register(tableViewCell, forCellReuseIdentifier: K.table.reuseId)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfEvents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.table.reuseId, for: indexPath) as! EventTableViewCell
        
        cell.eventNameLabel.text = arrayOfEvents[indexPath.section][indexPath.row].name
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
        cell.eventDateLabel.text = dateFormatter.string(from: arrayOfEvents[indexPath.section][indexPath.row].end)
        let daysRemaining = arrayOfEvents[indexPath.section][indexPath.row].end.daysToEvent.day!
        cell.daysRemainingLabel.text = String(daysRemaining)
        if daysRemaining == 1 {
            cell.daysLabel.text = "day"
        } else {
            cell.daysLabel.text = "days"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(identifier: K.VcId.detailViewVC) as? DetailViewController {
            vc.title = arrayOfEvents[indexPath.section][indexPath.row].name
            vc.event = arrayOfEvents[indexPath.section][indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [self.arrayOfEvents[indexPath.section][indexPath.row].name])
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, actionPerformed) in
            self.db.collection(K.FStore.collectionName).document("\(Auth.auth().currentUser!.uid)\(self.arrayOfEvents[indexPath.section][indexPath.row].name)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("deleted Data")
                    
                    DispatchQueue.main.async {
                        self.eventsTableView.reloadData()
                    }
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

