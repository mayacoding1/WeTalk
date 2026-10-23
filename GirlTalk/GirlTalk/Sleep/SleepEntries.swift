//
//  SleepEntries.swift
//  GirlTalk
//
//  Created by Maya M on 9/28/26.
//

import SwiftUI
import SwiftData
import Foundation

struct SleepEntries: View {
    @Query(sort: \SleepLog.date)
    private var sleepLogs: [SleepLog]
    @Environment(\.modelContext) private var context
    
    var body: some View{
        VStack{
            ScrollView{
                if (sleepLogs.isEmpty){
                    Label("No sleep entries yet", systemImage: "exclamationmark.circle.fill")
                        .padding(.top, 50)
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundStyle(.gray)
                } else {
                    ForEach(sleepLogs) { sleepLog in
                        sleepEntryDisplay(note: sleepLog.note, total: sleepLog.total, date: sleepLog.date, context: context, log: sleepLog)
                    }
                }
            }
        }
    }
}

struct sleepEntryDisplay: View{
    let note: String
    let total: Double
    let date: Date
    let context: ModelContext
    let log: SleepLog
    
    @State private var delEntry = false
    
    var body: some View{
        VStack{
            VStack{
                HStack{
                    Text("Sleep Entry")
                        .fontWeight(.bold)
                        .frame(maxWidth: 500, alignment: .leading)
                        .font(.body.lowercaseSmallCaps())
                        .opacity(0.5)
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .frame(maxWidth: 1000, alignment: .trailing)
                }
                
                Divider()
                
                Text("\(note)")
                    .padding(.top, 10)
                    .frame(maxWidth: 500, alignment: .leading)
            }
            .padding()
            .frame(maxWidth: 500, alignment: .leading)
            .padding(.bottom, 15)

            VStack{
                HStack{
                    Image(systemName: "clock.fill")
                        .foregroundStyle(.tint)
                        .font(.system(size:20))
                        .frame(maxWidth: 30, alignment: .leading)
                    
                    HStack{
                        Text("Total:")
                            .fontWeight(.bold)
                            .font(.body.lowercaseSmallCaps())
                            .opacity(0.5)
                        Text(String(format: "%0.1f", total))
                            .fontWeight(.bold)
                            
                    }
                    .padding(8)
                    .background(total >= 8 ? Color.lightGreenish.opacity(0.5) : total >= 7 ? Color.yellow.opacity(0.25) : Color.lightReddish.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: 300, alignment: .leading)
                    
                    Button("Delete", systemImage: "trash.circle.fill"){
                        delEntry = true
                    }
                    .labelStyle(.iconOnly)
                    .font(.system(size:30))
                    .confirmationDialog("Discard Entry", isPresented: $delEntry) {
                        Button("Discard Entry", role: .destructive) {
                            withAnimation{
                                context.delete(log)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.lightRose.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

#Preview{
    SleepEntries()
        .modelContainer(for: SleepLog.self)
}
