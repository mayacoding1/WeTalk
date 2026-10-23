//
//  Entry.swift
//  GirlTalk
//
//  Created by Maya M on 7/31/26.
//this is a test!

import Foundation
import SwiftData

@Model
class Entry {
    var negative: String
    var positive: String
    var category: String?
    
    init(negative: String, positive: String, category: String) {
        self.negative = negative
        self.positive = positive
        self.category = category
    }
}


extension Entry {
    static let sample = sampleData[0]
    
    static let sampleData = [
        Entry(
            negative: "They're staring",
            positive: "I hope they are not",
            category: "None"
        ),
        Entry(
            negative: "They're mean",
            positive: "They're nice",
            category: "None"
        )
    ]
}

