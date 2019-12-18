//
//  K.swift
//  Eventually
//
//  Created by Arthur Ford on 12/16/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation

struct K {
    
    static let longDate = "EEE MMM dd YYYY"
    
    struct Segues {
        static let signInSegueID = "signInSegue"
        static let signUpSegueID = "signUpSegue"
        static let signedInSegueID = "signedInSegue"
        static let signedUpSegueID = "signedUpSegue"
        static let detailViewSegueID = "detailViewSegue"
        static let newEventSegueID = "newEventSegue"
        static let editEventSegueID = "editEventSegue"
        static let unwindToEventsID = "unwindToEvents"
        static let unwindToRootID = "unwindToRoot"
    }
    
    struct FStore {
        static let collectionName = "Events"
        static let userId = "userId"
        static let end = "end"
        static let start = "start"
        static let name = "name"
        static let notes = "notes"
    }
    
    struct VcId {
        static let newEventVC = "NewEvent"
        static let detailViewVC = "DetailView"
        static let editEventVC = "EditEventViewController"
        static let masterVCID = "MasterViewController"
    }
    
    struct table {
        static let nibName = "EventTableViewCell"
        static let reuseId = "EventCell"
    }
}
