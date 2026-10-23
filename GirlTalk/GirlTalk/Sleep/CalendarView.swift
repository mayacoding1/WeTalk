//
//  CalendarView.swift
//  GirlTalk
//
//  Created by Maya M on 9/29/26.
//

import SwiftUI
import SwiftData
import Foundation

struct CalendarView: View{
    @State private var date = Date.now
    @State private var color: Color = .lightRose

    //Calendar info
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    let columns = Array(repeating:GridItem(.flexible()), count: 7)
//    var dayOffset = [[4, 31], [0, 28], [0, 31], [3,30], [5,31]]
    
    var days = 1..<36
    @State var dayoffset = 4
    @State var totalDays = 1..<31
    
    //Sleep log info
    @Query(sort: \SleepLog.date)
    private var sleepLogs: [SleepLog]
    @Environment(\.modelContext) private var context

    var body: some View{
        ScrollView{
            VStack{
                LabeledContent("Date"){
                    DatePicker("", selection: $date, displayedComponents: [.date])
                }
                HStack{
                    ForEach(daysOfWeek, id: \.self){ dayOfWeek in
                        Text(dayOfWeek)
                            .fontWeight(.bold)
                            .foregroundStyle(.tint)
                            .frame(maxWidth: .infinity)
                    }
                }
                LazyVGrid(columns:columns){
                    ForEach(days, id: \.self){ day in
                        if(day >= 5){
                            ZStack{
                                Button("\(day-4)", systemImage: "circle.fill"){
                                    withAnimation{
                                        let components = DateComponents(calendar: Calendar.current, year: 2026, month: 10, day:(day-4))
                                        date = Calendar.current.date(from: components) ?? Date.now
                                    }
                                }
                                .font(.system(size:45))
                                .labelStyle(.iconOnly)
                                .foregroundStyle(
                                    day-4 == Calendar.current.component(.day, from: date) ? .accent.opacity(0.5) : color
                                )
                                
                                Text("\(day-4)")
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
                    if Calendar.current.component(.day, from: sleepLog.date) == Calendar.current.component(.day, from: date){
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
    }
    func calcDays() -> Range<Int>{
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        let numDays = range.count

        totalDays = 1..<numDays
        
        return totalDays
    }
    
    mutating func calcOffset() -> Int{
        let components = DateComponents(calendar: Calendar.current, year: 2026, month: 10, day:1)
        let weekday = Int(Calendar.current.component(.weekday, from: Calendar.current.date(from: components) ?? date))
        
        dayoffset = Int(weekday - 1)
        
        return dayoffset
    }
}

#Preview{
    CalendarView()
        .modelContainer(for: SleepLog.self)
}
