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
    var start = Calendar.current.date(bySetting: .hour, value: 12, of: Date())
    var end = Calendar.current.date(bySetting: .hour, value: 12, of: Date())
    var notes: String = ""
    var userId: String = ""
}
