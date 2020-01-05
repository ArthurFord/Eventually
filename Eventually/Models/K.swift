//
//  K.swift
//  Eventually
//
//  Created by Arthur Ford on 12/16/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation
import UIKit

struct K {
    
    static let longDate = "EEE MMM dd yyyy"
    static let dateAndTime = "EEE MMM dd yyyy, h:mm a"
    static let authLabel = "authLabel"
    static let settingsCellReuseID = "settingsCell"
    
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
        static let toWebKitViewSegueID = "toWebKitViewSegue"
        static let settingsSegueID = "settingsSegue"
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
        static let settingsViewControllerID = "settingsViewController"
        static let editEventViewControllerID = "editEventViewController"
    }
    
    struct table {
        static let nibName = "EventTableViewCell"
        static let reuseId = "EventCell"
    }
    
    struct ThemeNames {
        static let natureTheme = "natureTheme"
        static let cuteGamerTheme = "cuteGamerTheme"
        static let beachTheme = "beachTheme"
        static let blackAndWhiteTheme = "blackAndWhiteTheme"
    }
    
    struct Colors {
        
        struct Natural {
            static let naturalBackground = "NaturalBackground"
            static let naturalBottomText = "NaturalBottomText"
            static let naturalCellBackground = "NaturalCellBackground"
            static let naturalTopText = "NaturalTopText"
        }
        
        struct CuteGamer {
            
            static let cuteGamerBackground = "CuteGamerBackground"
            static let cuteGamerCellBackground = "CuteGamerCellBackground"
            static let cuteGamerTopText = "CuteGamerTopText"
            static let cuteGamerBottomText = "CuteGamerBottomText"
            
        }
        
        struct Beach {
            
            static let beachBackground = "BeachBackground"
            static let beachBottomText = "BeachBottomText"
            static let beachCellBackground = "BeachCellBackground"
            static let beachTopText = "BeachTopText"
           
        }
        
        struct BlackAndWhite {
            static let defaultCellBackground = "DefaultCellBackground"
        }
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





extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
}
