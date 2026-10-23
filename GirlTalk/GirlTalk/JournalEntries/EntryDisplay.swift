//
//  EntryDisplay.swift
//  GirlTalk
//
//  Created by Maya M on 8/15/26.
//

import SwiftUI
import SwiftData

struct EntryDisplay<Content: View>: View{
    var entry: Entry? = nil
    @State private var showPos = false
    @State private var insideText = ""
    @State private var outsideText = "_The worry:_"
    @State private var confirmation = false
    
    @Query
    private var entries: [Entry]
    @Environment(\.modelContext) private var context
    
//    @Environment(EntryContainer.self) private var entryContainer
//    
    @ViewBuilder var content: () -> Content
    
    var body: some View{
        HStack{
            VStack{
                Text(!showPos ? "Worry:" : "New outlook:")
                    .fontWeight(.bold)
                    .padding(.top)
                    .font(.body.lowercaseSmallCaps())
                    .opacity(0.5)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    
                VStack{
                    Text(!showPos ? (entry?.negative ?? ""):(entry?.positive ?? ""))
                        .padding(.top, 10)
                        .padding(.bottom, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 18))
                    
                    HStack{
                        Spacer()
                        Button("Show next", systemImage: "arrowshape.turn.up.right.circle.fill"){
                            withAnimation(.easeInOut){
                                showPos.toggle()
                            }
                        }
                        .labelStyle(.iconOnly)
                        .font(.system(size:30))
                        .foregroundStyle(.tint)
                        .fontWeight(.semibold)
                        
                        Button("delete", systemImage: "trash.circle.fill"){
                            confirmation = true
                        }
                        .labelStyle(.iconOnly)
                        .font(.system(size:30))
                        .foregroundStyle(.tint)
                        .fontWeight(.semibold)
                        
                        .confirmationDialog("Discard Entry", isPresented: $confirmation) {
                            Button("Discard Entry", role: .destructive) {
                                withAnimation(.easeInOut){
//                                    entryContainer.context.delete(entry!)
//                                    try? entryContainer.context.save()
                                    
                                    context.delete(entry!)
                                    try? context.save()
                                }
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 15)
            }
            .padding(.horizontal, 15)            
            
            .background(!showPos ? Color.lightRose.opacity(0.5) : Color.lightGreenish.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
            .padding()
    
            content()
                .padding()
        }
    }
}

//#Preview{
//    EntryDisplay(entry: Entry.sampleData[0]){
//    }
//    .sampleEntryContainer()
//}
