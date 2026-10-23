//
//  SleepReminder.swift
//  GirlTalk
//
//  Created by Maya M on 9/9/26.
//

import Foundation
import SwiftData

@Model
class SleepReminder{
    var reminder: String
    var time: Date
    var isStarred: Bool
    
    init(reminder: String, time: Date, isStarred: Bool) {
        self.reminder = reminder
        self.time = time
        self.isStarred = isStarred
    }
}
