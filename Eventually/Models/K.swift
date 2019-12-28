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
    static let dateAndTime = "EEE MMM dd YYYY, h:mm a"
    static let GADTSmallTemplateViewID = "GADTSmallTemplateView"
    static let authLabel = "authLabel"
    
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
        static let straightToEventsAfterAuthID = "straightToEventsAfterAuth"
        static let setDateSegueID = "setDateSegue"
        static let unwindSetDateToNewViewID = "unwindSetDateToNewView"
        static let unwindToNewEventFromReminderID = "unwindToNewEventFromReminder"
    }
    
    struct FStore {
        static let collectionName = "Events"
        static let userId = "userId"
        static let end = "end"
        static let start = "start"
        static let name = "name"
        static let notes = "notes"
        static let reminder = "reminder"
        static let reminderOn = "reminderOn"
    }
    
    struct VcId {
        static let newEventVC = "NewEvent"
        static let detailViewVC = "DetailView"
        static let editEventVC = "EditEventViewController"
        static let masterVCID = "MasterViewController"
        static let datePickerViewControllerID = "datePickerViewController"
        static let setReminderViewControllerID = "setReminderViewController"
        static let signInViewControllerID = "signInViewController"
    }
    
    struct table {
        static let nibName = "EventTableViewCell"
        static let reuseId = "EventCell"
    }
    
    struct adInfo: Codable {
        var adUnitID: String
    }
}

struct Credentials {
    var username: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
