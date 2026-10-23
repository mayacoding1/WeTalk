//
//  Journal.swift
//  GirlTalk
//
//  Created by Maya M on 7/19/26.
//

import SwiftUI
import SwiftData

struct Journal: View{
    @State private var showNewEntrySheet = false
    @State private var showNewCategorySheet = false
    
    @Query(sort: \EntryCategory.category)
    private var entryCategories: [EntryCategory]
        
//    @Query
//    private var entries: [Entry]
    
    @Query
    private var entries: [Entry]
    @Environment(\.modelContext) private var context
    
    var body: some View{
        NavigationStack{
            ScrollView{
                VStack{
                    Text("Write about it")
                        .padding()
                        .font(.system(size: 40))
                        .background(.tint, in: RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .padding(.bottom, 30)
                    
                    if (entries.isEmpty){
                        Label("No entries yet", systemImage: "exclamationmark.circle.fill")
                            .padding(.top, 50)
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundStyle(.gray)
                    } else {
                        if anyCategories(){
                            ForEach(entryCategories) { entryCategory in
                                if hasCategory(thisEntryCategory: entryCategory.category){
                                    VStack(alignment: .leading){
                                        Text("\(entryCategory.category)")
                                            .fontWeight(.bold)
                                            .font(.system(size: 40))
                                            .foregroundStyle(.tint)
                                            .padding(6)
                                        Text("\(entryCategory.info)")
                                            .padding()
                                        Divider()
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    ForEach(entries.reversed()) { entry in
                                        if (entry.category == entryCategory.category){
                                            EntryDisplayView(entry: entry)
                                                .frame(maxWidth: 500, minHeight: 10, maxHeight: 350)
                                                .padding(.horizontal)
                                                .padding(.vertical, 4)
                                        }
                                    }
                                }
                            }
                            if anyNoCategory(){
                                VStack(alignment: .leading){
                                    Text("No Category")
                                        .fontWeight(.bold)
                                        .font(.system(size: 40))
                                        .foregroundStyle(.tint)
                                        .padding(6)
                                    Divider()
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                ForEach(entries.reversed()) { entry in
                                    if (entry.category == "none"){
                                        EntryDisplayView(entry: entry)
                                            .frame(maxWidth: 500, minHeight: 10, maxHeight: 350)
                                            .padding(.horizontal)
                                            .padding(.vertical, 4)
                                    }
                                }
                            }
                            
                        } else {
                            VStack(alignment: .leading){
                                Text("No Category")
                                    .fontWeight(.bold)
                                    .font(.system(size: 40))
                                    .foregroundStyle(.tint)
                                    .padding(6)
                                Divider()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(entries.reversed()) { entry in
                                EntryDisplayView(entry: entry)
                            }
                            .frame(maxWidth: 500, minHeight: 10, maxHeight: 350)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                        }
                    }
                    
                    
                    
                }
                .padding(.top, 20)
            }
            
            .toolbar {
                ToolbarItem{
                    Menu{
                        Button("New Entry") {
                            showNewEntrySheet.toggle()
                        }
                        Divider()
                        Button("New Category") {
                            showNewCategorySheet.toggle()
                        }
                        
                    } label: {
                        Label("Add Entry", systemImage: "plus")
                    }
                }
                
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Cancel", systemImage: "plus", role: .destructive) {
//                        showNewEntrySheet.toggle()
//                    }
//                }
            }
            
            .sheet(isPresented: $showNewEntrySheet){
                NewEntryView()
            }
            
            .sheet(isPresented: $showNewCategorySheet){
                NewEntryCategoryView()
            }
        }
    }
    func anyCategories() -> Bool{
        for entry in entries{
            if entry.category != "none"{
                return true
            }
        }
        return false
    }
    func anyNoCategory() -> Bool{
        for entry in entries{
            if entry.category == "none"{
                print("no categories")
                return true
            }
        }
        print("false")
        return false
    }
    func hasCategory(thisEntryCategory: String) -> Bool{
        for entry in entries{
            if entry.category == thisEntryCategory{
                return true
            }
        }
        return false
    }
}

#Preview {
    Journal()
//        .sampleEntryContainer()
    
        .environment(sampleContainer)
        .modelContainer(sampleContainer.modelContainer)
        .modelContainer(for: [EntryCategory.self, Entry.self])
}
