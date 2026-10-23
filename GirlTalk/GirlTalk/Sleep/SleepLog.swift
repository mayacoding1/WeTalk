//
//  SleepLog.swift
//  GirlTalk
//
//  Created by Maya M on 9/24/26.
//

import Foundation
import SwiftData

@Model
class SleepLog{
    var total: Double
    var note: String
    var date: Date
    
    init(total: Double, note: String, date: Date) {
        self.total = total
        self.note = note
        self.date = date
    }
}
