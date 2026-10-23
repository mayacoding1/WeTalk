//
//  NewSleepView.swift
//  GirlTalk
//
//  Created by Maya M on 9/24/26.
//

import SwiftUI
import SwiftData

struct NewSleepView: View {
    private var time = 7
    @State private var showSheet = false
    @Query(sort: \SleepLog.total)
    private var sleepLogs: [SleepLog]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var newLogTotal = ""
    @State private var newLogStartTime = Date(timeIntervalSince1970: 1790298000)
    @State private var newLogEndTime = Date(timeIntervalSince1970: 1790335800)
    @State private var newLogNote = ""
    
    //Added startingLog
    let startingLog: Date
    @State private var newLogDate = Date.now
    
    init(startingLog: Date) {
        self.startingLog = startingLog
        newLogDate = startingLog
        _newLogDate = State(initialValue: startingLog)
    }
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    HStack{
                        DatePicker("", selection: $newLogStartTime, displayedComponents: [.hourAndMinute])
                            .padding()
                            .labelsHidden()
                        
                        VStack{
                            Image(systemName: "deskclock")
                                .foregroundStyle(.tint)
                                .font(.system(size:100))
                            
                            DatePicker("", selection: $newLogDate, displayedComponents: [.date])
                                .padding()
                                .labelsHidden()
                        }
                        
                        DatePicker("", selection: $newLogEndTime, displayedComponents: [.hourAndMinute])
                            .padding()
                            .labelsHidden()
                        
                    }
                    
                    VStack{
                        Text("Sleep notes")
                            .fontWeight(.bold)
                            .padding(.top)
                            .font(.body.lowercaseSmallCaps())
                            .opacity(0.5)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                        
                        HStack{
                            TextField(text: $newLogNote, axis: .vertical){
                                Text("ex. \"A good night of sleep!\"")
                            }
                            .lineLimit(3...Int.max)
                            .fontWeight(.regular)
                        }
                        .padding()
                    }
                    .background(Color.lightRose.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .padding(.horizontal, 15)
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
                .padding()
            }
            .scrollDismissesKeyboard(.interactively)
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark", role: .destructive) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add log", systemImage: "checkmark", role: .destructive) {
                        let totalTime = Calendar.current.dateComponents(
                            [.hour, .minute],
                            from: newLogStartTime,
                            to: newLogEndTime
                        )
                        let sleptTime = Double(totalTime.hour!) + Double(totalTime.minute!)/60
                        
                        let newSleepLog = SleepLog(total: sleptTime, note: newLogNote, date: newLogDate)
                        
                        print(sleptTime)
                        print(totalTime.hour!)
                        context.insert(newSleepLog)
                        try? context.save()
                        
                        print(newLogDate)
                        print(sleepLogs)
                        print("test message")
                        
                        dismiss()
                    }
                }
            }
        }
    }
}



//#Preview {
//    NewSleepView()
//        .modelContainer(for: SleepLog.self)
//}
