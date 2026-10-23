//
//  EntryContainer.swift
//  GirlTalk
//
//  Created by Maya M on 8/2/26.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
class EntryContainer {
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    init(includeSampleEntries: Bool = false ) {
        let schema = Schema ([
            Entry.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: includeSampleEntries)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            if (includeSampleEntries){
                loadSampleEntries()
            }
            try context.save()
            
        } catch {
            fatalError("Unable to create ModelContainer: \(error)")
        }
    }
    
    private func loadSampleEntries() {
        for entry in Entry.sampleData{
            context.insert(entry)
        }
    }
}

/*private*/ let sampleContainer = EntryContainer(includeSampleEntries: true)

extension View {
    func sampleEntryContainer() -> some View {
        self
            .environment(sampleContainer)
            .modelContainer(sampleContainer.modelContainer)
    }
}

