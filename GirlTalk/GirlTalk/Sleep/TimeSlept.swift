//
//  TimeSlept.swift
//  GirlTalk
//
//  Created by Maya M on 9/21/26.
//

import SwiftUI
import SwiftData

struct TimeSlept: View {
    private var time = 7
    @State private var showSheet = false
    @Query(sort: \SleepLog.total)
    private var sleepLogs: [SleepLog]
    @Environment(\.modelContext) private var context
    
    var realTime: Double {
        return sleepLogs.reduce(0.0){total, sleepLog in
            total + sleepLog.total
        }/Double(sleepLogs.count>1 ? sleepLogs.count : 1)
    }
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Text("Time slept")
                        .fontWeight(.bold)
                        .frame(maxWidth: 500, alignment: .leading)
                        .font(.body.lowercaseSmallCaps())
                        .opacity(0.5)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    VStack{
                        HStack{
                            VStack{
                                Text(String(format: "%0.1f", realTime))
                                    .font(.system(size:70))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.tint)
                                
                                Text("hour average")
                                    .font(.caption)
                            }
                            .padding()
                            
                            VStack{
                                if(realTime>=8){
                                    Text("Well above the minimum!")
                                } else if(realTime>=7){
                                    Text("Within the minimum!")
                                } else{
                                    Text("Try to get some more sleep!")
                                }
                            }
                            .padding()
                            .background(realTime >= 8 ? Color.lightGreenish.opacity(0.5) : realTime >= 7 ? Color.yellow.opacity(0.25) : Color.lightReddish.opacity(0.25), in: RoundedRectangle(cornerRadius: 10))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                            .frame(width: realTime >= 10 ? 110 : 130)
                        }
                        
                        HStack{
                            NavigationLink(destination: TestCalendarView()){
                                Label("See all sleep logs", systemImage: "info.circle.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.system(size:25))
                                    .labelStyle(.iconOnly)
                                    .frame(maxWidth: 500, alignment: .trailing)
                            }
                            
//                            Button("Show next", systemImage: "plus.circle.fill"){
//                                withAnimation(.easeInOut){
//                                    showSheet.toggle()
//                                }
//                            }
//                            .labelStyle(.iconOnly)
//                            .font(.system(size:25))
//                            .foregroundStyle(.tint)
//                            
//                            .sheet(isPresented: $showSheet){
//                                NewSleepView(startingLog: Date.now)
//                            }
//                            

                        }
                    }
                    .frame(maxWidth: 500, alignment: .leading)
                    .padding()
                }
                .background(Color.lightRose.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 10)
            .padding()
            .scrollDismissesKeyboard(.interactively)
        }
    }
}



#Preview {
    TimeSlept()
        .modelContainer(for: SleepLog.self)
}
