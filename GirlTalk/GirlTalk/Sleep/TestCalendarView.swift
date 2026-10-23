//
//  TestCalendarView.swift
//  GirlTalk
//
//  Created by Maya M on 9/29/26.
//

import SwiftUI
import SwiftData
import Foundation

struct TestCalendarView: View{
    @State private var date = Date.now
    @State private var color: Color = .lightRose
    @State private var showSheet = false

    //Calendar info
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let columns = Array(repeating:GridItem(.flexible()), count: 7)
    
    var days = 1..<36
    @State private var dayoffset = 4
    @State private var totalDays = 1..<36
    @State private var month = 10
    
    //Sleep log info
    @Query(sort: \SleepLog.date)
    private var sleepLogs: [SleepLog]
    @Environment(\.modelContext) private var context

    var body: some View{
        NavigationStack{
            ScrollView{
                VStack{
                    HStack{
                        Button("previous month", systemImage: "arrow.backward"){
                            withAnimation{
                                month = month - 1
                                let components = DateComponents(calendar: Calendar.current, year: 2026, month: month, day:1)
                                date = Calendar.current.date(from: components) ?? Date.now
                                dayoffset = calcOffset()
                                totalDays = calcDays()
                            }
                        }
                        .disabled(month == 1)
                        .font(.system(size:45))
                        .labelStyle(.iconOnly)
                        .padding()
                        
                        Text("\(months[month - 1])")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Button("next month", systemImage: "arrow.forward"){
                            withAnimation{
                                month = month + 1
                                let components = DateComponents(calendar: Calendar.current, year: 2026, month: month, day:1)
                                date = Calendar.current.date(from: components) ?? Date.now
                                totalDays = calcDays()
                                dayoffset = calcOffset()
                            }
                        }
                        .disabled(month == 12)
                        .font(.system(size:45))
                        .labelStyle(.iconOnly)
                        .padding()
                    }
                    .padding()
                    
                    HStack{
                        ForEach(daysOfWeek, id: \.self){ dayOfWeek in
                            Text(dayOfWeek)
                                .fontWeight(.bold)
                                .foregroundStyle(.tint)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    LazyVGrid(columns:columns){
                        ForEach(totalDays, id: \.self){ day in
                            if(day > dayoffset){
                                ZStack{
                                    Button("\(day-dayoffset)", systemImage: "circle.fill"){
                                        withAnimation{
                                            let components = DateComponents(calendar: Calendar.current, year: 2026, month: month, day:(day-dayoffset))
                                            date = Calendar.current.date(from: components) ?? Date.now
                                        }
                                    }
                                    .font(.system(size:45))
                                    .labelStyle(.iconOnly)
                                    .foregroundStyle(
                                        day-dayoffset == Calendar.current.component(.day, from: date) ? .accent.opacity(0.5) : hasEntry(day: day, sleepLogs: sleepLogs) ? .yellow.opacity(0.5) : color
                                    )
                                    
                                    Text("\(day-dayoffset)")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .allowsHitTesting(false)
                                }
                            } else{
                                Text("")
                            }
                        }
                    }
                    
                    ForEach(sleepLogs) { sleepLog in
                        if Calendar.current.dateComponents([.month, .day], from: sleepLog.date) == Calendar.current.dateComponents([.month, .day], from: date){
                            withAnimation{
                                sleepEntryDisplay(note: sleepLog.note, total: sleepLog.total, date: sleepLog.date, context: context, log: sleepLog)
                            }
                        }
                    }
                }
                .padding()
                .padding()
            }
            .animation(.easeInOut, value: date)
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Show next", systemImage: "plus"){
                        withAnimation(.easeInOut){
                            showSheet.toggle()
                        }
                    }
                    .font(.system(size:25))
                    
                    .sheet(isPresented: $showSheet){
                        NewSleepView(startingLog: date)
                    }
                }
            }
        }
    }
    
    func calcDays() -> Range<Int>{
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        let numDays = range.count + calcOffset() + 1

        totalDays = 1..<numDays
        
        return totalDays
    }
    
    func calcOffset() -> Int{
        let components = DateComponents(calendar: Calendar.current, year: 2026, month: month, day:1)
        let weekday = Int(Calendar.current.component(.weekday, from: Calendar.current.date(from: components) ?? date))
        
        dayoffset = weekday - 1
        print(type(of: sleepLogs))
        return dayoffset
    }
    
    func hasEntry(day: Int, sleepLogs: Array<SleepLog>) -> Bool {
        let buttonDate = DateComponents(calendar: Calendar.current, year: 2026, month: month, day:(day-dayoffset))
        guard let composedButtonDate = Calendar.current.date(from: buttonDate) else { return false }
        
        for sleepLog in sleepLogs{
            if Calendar.current.dateComponents([.month, .day], from: sleepLog.date) == Calendar.current.dateComponents([.month, .day], from: composedButtonDate){
                return true
            }
        }
        return false
    }
}

#Preview{
    TestCalendarView()
        .modelContainer(for: SleepLog.self)
}
