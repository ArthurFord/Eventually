//
//  Event.swift
//  Eventually
//
//  Created by Arthur Ford on 12/15/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation

class Event {
    var name: String = ""
    var start =  Date()
    var end = Calendar.current.startOfDay(for: Date())
    var notes: String = ""
    var userId: String = ""
    var reminder: Date?
    var reminderOn = false
}
