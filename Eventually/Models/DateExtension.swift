//
//  DateExtension.swift
//  Eventually
//
//  Created by Arthur Ford on 12/15/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation

extension Date {
    var daysToEvent: DateComponents {
        
        
        let now = Calendar.current.startOfDay(for: Date())
        let then = Calendar.current.startOfDay(for: self)
        
        return Calendar.current.dateComponents([.day], from: now, to: then)
        
    }
}
