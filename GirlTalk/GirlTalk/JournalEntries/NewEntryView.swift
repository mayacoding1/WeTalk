//
//  NewEntryView.swift
//  GirlTalk
//
//  Created by Maya M on 8/2/26.
//

import SwiftUI
import SwiftData

struct NewEntryView: View{
    @State private var negative = ""
    @State private var positive = ""
    @State private var deleteEntry = false
    @State private var newCategory = "none"
    
    @Query(sort: \EntryCategory.category)
    private var entryCategories: [EntryCategory]
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
//    @Environment(EntryContainer.self) private var entryContainer
    
    var body: some View{
        NavigationStack{
            ScrollView{
                content
            }
            
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark", role: .destructive) {
                        if (!negative.isEmpty && !positive.isEmpty){
                            deleteEntry = true
                        } else{
                            dismiss()
                        }
                    }
                    .confirmationDialog("Discard Entry", isPresented: $deleteEntry) {
                        Button("Discard New Entry", role: .destructive) {
                            dismiss()
                            print(entryCategories)
                        }
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") {
                        let newEntry = Entry(
                            negative: negative,
                            positive: positive,
                            category: newCategory
                        )
                        context.insert(newEntry)
                        print("\(newCategory)")
                        do {
                            try context.save()
                            dismiss()

                        } catch {

                        }
                    }
                    .disabled(negative.isEmpty || positive.isEmpty)
                }
            }
        }
    }
    
    var content: some View{
        VStack{
            Text("New Entry")
                .padding()
                .font(.system(size: 40))
                .background(.tint, in: RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
                .padding(6)
            
            
            Menu(newCategory == "none" ? "Entry Category" : "\(newCategory)"){
                Button("None") {
                    newCategory = "none"
                }
                if (!entryCategories.isEmpty){
                    ForEach(entryCategories) { entryCategory in
                        Button("\(entryCategory.category)") {
                            newCategory = entryCategory.category
                        }
                        Divider()
                    }
                }
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.black)
            
            negativeThought
                .padding(.horizontal, 10)
            
            Divider()
                .padding(.vertical, 30)
            
            positiveThought
                .opacity(negative.count < 5 ? 0 : 1)
                .animation(.easeIn, value: negative.count)
                .padding(.horizontal, 10)
        }
    }
    
    var negativeThought: some View{
        VStack{
            Text("Write a worry you may have")
                .fontWeight(.bold)
                .padding(.top)
                .font(.body.lowercaseSmallCaps())
                .opacity(0.5)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            HStack{
                TextField(text: $negative, axis: .vertical){
                    Text("ex. \"Everyone is staring at me\"")
                }
                .lineLimit(3...Int.max)
            }
            .padding()
        }
        .background(Color.lightRose.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
        .padding()
    }
    
    
    var positiveThought: some View{
        VStack{
            Text("Now turn that worry a bit positive")
                .fontWeight(.bold)
                .padding(.top)
                .font(.body.lowercaseSmallCaps())
                .opacity(0.5)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            HStack{
                TextField(text: $positive, axis: .vertical){
                    Text("ex. \"...But probably aren't\"")
                }
                .lineLimit(3...Int.max)
            }
            .padding()
        }
        .background(Color.lightRose.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

#Preview {
    NewEntryView()
        .sampleEntryContainer()
        .modelContainer(for: [EntryCategory.self])
}
