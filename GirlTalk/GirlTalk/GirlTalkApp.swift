//
//  GirlTalkApp.swift
//  GirlTalk
//
//  Created by Maya M on 7/12/26.
//

import SwiftUI
import SwiftData

@main
struct GirlTalkApp: App {
    let entryContainer = EntryContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(entryContainer)
        }
        .modelContainer(for: [SleepReminder.self, Entry.self, SleepLog.self, EntryCategory.self])
    }
}
