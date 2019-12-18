//
//  MasterViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/15/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit
import Firebase

class MasterViewController: UIViewController {
    
    var arrayOfEvents: [Event] = []
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        registerTableViewCells()
        navigationController?.navigationBar.tintColor = .label
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadEvents()
        
        
    }
    
    func loadEvents() {
        db.collection(K.FStore.collectionName)
            .whereField(K.FStore.userId, isEqualTo: Auth.auth().currentUser!.uid)
            .order(by: K.FStore.end)
            .addSnapshotListener { (querySnapshot, error) in
                self.arrayOfEvents = []
                if let err = error {
                    print("error getting data \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for document in snapshotDocuments {
                            let data = document.data()
                            
                            guard let startTimeStamp = data[K.FStore.start] as? Timestamp  else { return }
                            let startDate = startTimeStamp.dateValue()
                            let start = startDate
                            
                            guard let endTimeStamp = data[K.FStore.end] as? Timestamp  else { return }
                            let endDate = endTimeStamp.dateValue()
                            let end = endDate
                            
                            guard let name = data[K.FStore.name] as? String else {return}
                            guard let notes = data[K.FStore.notes] as? String else {return}
                            
                            let newEvent = Event()
                            newEvent.name = name
                            newEvent.end = end
                            newEvent.start = start
                            newEvent.notes = notes
                            self.arrayOfEvents.append(newEvent)
                            
                            DispatchQueue.main.async {
                                self.eventsTableView.reloadData()
                            }
                        }
                    }
                }
        }
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(identifier: K.VcId.newEventVC) as? NewEventViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        
    }
    
}
//MARK: - TableView Delegate

extension MasterViewController: UITableViewDelegate, UITableViewDataSource {
    func registerTableViewCells() {
        let tableViewCell = UINib(nibName: K.table.nibName, bundle: nil)
        self.eventsTableView.register(tableViewCell, forCellReuseIdentifier: K.table.reuseId)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.table.reuseId, for: indexPath) as! EventTableViewCell
        
        cell.eventNameLabel.text = arrayOfEvents[indexPath.row].name
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate(K.longDate)
        cell.eventDateLabel.text = dateFormatter.string(from: arrayOfEvents[indexPath.row].end)
        cell.daysRemainingLabel.text = String(arrayOfEvents[indexPath.row].end.daysToEvent.day!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(identifier: K.VcId.detailViewVC) as? DetailViewController {
            vc.title = arrayOfEvents[indexPath.row].name
            vc.event = arrayOfEvents[indexPath.row]
            vc.eventIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, actionPerformed) in
            self.db.collection(K.FStore.collectionName).document("\(Auth.auth().currentUser!.uid)\(self.arrayOfEvents[indexPath.row].name)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("deleted Data")
                    self.loadEvents()
                    DispatchQueue.main.async {
                        self.eventsTableView.reloadData()
                    }
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
