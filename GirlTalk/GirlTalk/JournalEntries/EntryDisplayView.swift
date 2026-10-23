//
//  EntryDisplayView.swift
//  GirlTalk
//
//  Created by Maya M on 8/15/26.
//

import SwiftUI

struct EntryDisplayView: View {
    var entry: Entry
    
    var body: some View {
        EntryDisplay(entry: entry){
        }
    }
}

#Preview{
    EntryDisplayView(entry: Entry.sampleData[0])
        .sampleEntryContainer()
    EntryDisplayView(entry: Entry.sampleData[0])
        .sampleEntryContainer()
}
