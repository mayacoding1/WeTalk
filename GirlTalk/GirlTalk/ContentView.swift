//
//  ContentView.swift
//  GirlTalk
//
//  Created by Maya M on 7/12/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        Home()
    }
}

#Preview {
    ContentView()
//        .sampleEntryContainer()
//        .modelContainer(for: SleepReminder.self)
    
        .modelContainer(for: [SleepReminder.self, Entry.self, SleepLog.self, EntryCategory.self])
    
//        .environment(sampleContainer)
//        .modelContainer(sampleContainer.modelContainer)
    

}
