//
//  NewEntryCategoryView.swift
//  GirlTalk
//
//  Created by Maya M on 10/16/26.
//

import SwiftUI
import SwiftData

struct NewEntryCategoryView: View {
    @State private var category = ""
    @State private var info = ""
    @State private var deleteCategory = false
    
    @Query(sort: \EntryCategory.id)
    private var entryCategories: [EntryCategory]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack{
                    Text("New Journal Category")
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    TextField(text: $category, axis: .vertical){
                        Text("Title")
                    }
                    .padding()
                    .font(.system(size: 40))
                    .background(.tint, in: RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.white)
                    .lineLimit(1...Int.max)
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    Divider()
                        .padding(20)
                    
                    VStack{
                        Text("Category Description")
                            .fontWeight(.bold)
                            .padding(.top)
                            .font(.body.lowercaseSmallCaps())
                            .opacity(0.5)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                        
                        HStack{
                            TextField(text: $info, axis: .vertical){
                                Text("...")
                            }
                            .lineLimit(1...2)
                        }
                        .padding()
                    }
                    .background(Color.lightRose.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                    .padding()
                    
                }
            }
            .scrollDismissesKeyboard(.interactively)
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark", role: .destructive) {
                        if (!category.isEmpty && !info.isEmpty){
                            deleteCategory = true
                        } else{
                            dismiss()
                        }
                    }
                    .confirmationDialog("Discard Entry", isPresented: $deleteCategory) {
                        Button("Discard Category", role: .destructive) {
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add Category", systemImage: "checkmark", role: .destructive) {
                        let newCategory = EntryCategory(category: category, info: info)
                        context.insert(newCategory)
                        try? context.save()
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    NewEntryCategoryView()
        .modelContainer(for: [EntryCategory.self])
}
