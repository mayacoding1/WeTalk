//
//  EntryCategory.swift
//  GirlTalk
//
//  Created by Maya M on 10/16/26.
//

import Foundation
import SwiftData

@Model
class EntryCategory{
    var category: String
    var info: String
    
    init(category: String, info: String) {
        self.category = category
        self.info = info
    }
}
