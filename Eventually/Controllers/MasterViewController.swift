//
//  MasterViewController.swift
//  Eventually
//
//  Created by Arthur Ford on 12/15/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class MasterViewController: UIViewController {
    
    var arrayOfEvents: [Event] = []
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    @IBOutlet weak var adPlaceholderView: UIView!
    
    var nativeAdView: GADUnifiedNativeAdView!
    
    var nativeAd = GADUnifiedNativeAd()
    
    var adLoader: GADAdLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        registerTableViewCells()
        
        
        navigationController?.navigationBar.tintColor = .label
        
        nativeAdView = (UINib(nibName: K.GADTSmallTemplateViewID, bundle: .main).instantiate(withOwner: nil, options: nil).first as! GADUnifiedNativeAdView)
        
        setAdView(nativeAdView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadEvents()
        loadAd()
    }
    
    func loadEvents() {
        let calendar = Calendar.current
        let cutOffDate = calendar.date(byAdding: .day, value: -1, to: Date())!
        let cutOffDateStored = calendar.startOfDay(for: cutOffDate)
        
        print("cutoff = \(cutOffDateStored)")
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
                            
                            guard let endTimeStamp = data[K.FStore.end] as? Timestamp  else { return }
                            let endDate = endTimeStamp.dateValue()
                            
                            guard let name = data[K.FStore.name] as? String else {return}
                            guard let notes = data[K.FStore.notes] as? String else {return}
                            
                            let newEvent = Event()
                            newEvent.name = name
                            newEvent.end = endDate
                            newEvent.start = startDate
                            newEvent.notes = notes
                            print("end = \(newEvent.end)")
                            let startOfDayEndDate = calendar.startOfDay(for: newEvent.end)
                            if startOfDayEndDate > cutOffDateStored {
                                self.arrayOfEvents.append(newEvent)
                            }
                            
                            
                            DispatchQueue.main.async {
                                self.eventsTableView.reloadData()
                            }
                        }
                    }
                }
        }
        
    }
    
    func loadAd() {
        
        var adUnitID = ""
        let numAdsToLoad = 1
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"){
            guard let xml = FileManager.default.contents(atPath: path) else { return }
            do {
                let info = try PropertyListDecoder().decode(K.adInfo.self, from: xml)
                adUnitID = info.adUnitID
            } catch  {
                print(error)
            }
        }
        
        let options = GADMultipleAdsAdLoaderOptions()
        options.numberOfAds = numAdsToLoad
        
        // Prepare the ad loader and start loading ads.
        adLoader = GADAdLoader(adUnitID: adUnitID,
                               rootViewController: self,
                               adTypes: [.unifiedNative],
                               options: [options])
        adLoader.delegate = self
        adLoader.load(GADRequest())
        
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
        let daysRemaining = arrayOfEvents[indexPath.row].end.daysToEvent.day!
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
                    self.arrayOfEvents.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.eventsTableView.reloadData()
                    }
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
// MARK: - Ad Loader Delegate

extension MasterViewController: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader,
                  didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
        
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("Received native ad: \(nativeAd)")
        self.nativeAd = nativeAd
        self.nativeAd.delegate = self
        // Add the native ad to the list of native ads.
        nativeAdView.nativeAd = nativeAd
        (nativeAdView.headlineView as! UILabel).text = nativeAd.headline
        (nativeAdView.advertiserView as! UILabel).text = nativeAd.advertiser
        (nativeAdView.callToActionView as! UIButton).setTitle(nativeAd.callToAction, for: .normal)
        (nativeAdView.callToActionView as! UIButton).isUserInteractionEnabled = false
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
    }
    
    func setAdView(_ view: GADUnifiedNativeAdView) {
        adPlaceholderView.addSubview(view)
        
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
    }
}

// MARK: - GADUnifiedNativeAdDelegate
extension MasterViewController : GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
}
