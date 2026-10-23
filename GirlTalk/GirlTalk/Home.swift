//
//  Home.swift
//  GirlTalk
//
//  Created by Maya M on 7/12/26.
//

import SwiftUI
import SwiftData

struct Home: View {
    @Query(sort: \SleepReminder.time)
    private var sleepReminders: [SleepReminder]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    top
                        .padding()
                    buttons
                    
                    if allStarred(){
                        VStack{
                            Text("Starred Reminders")
                                .fontWeight(.bold)
                                .frame(maxWidth: 500, alignment: .leading)
                                .font(.body.lowercaseSmallCaps())
                                .opacity(0.5)
                                .padding()
                            Divider()
                            ForEach(sleepReminders) { sleepReminder in
                                if (sleepReminder.isStarred) {
                                    HStack(alignment: .center){
                                        Button("Reminder done", systemImage:  "circle"){
                                            withAnimation(.easeInOut){
                                                context.delete(sleepReminder)
                                            }
                                        }
                                        .labelStyle(.iconOnly)
                                        .imageScale(.large)
                                        .font(.system(size:24))
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(.tint)
                                        .fontWeight(.light)
                                        .opacity(0.7)
                                        
                                        VStack(alignment: .leading){
                                            Text(sleepReminder.reminder)
                                            
                                            Text(sleepReminder.time, format: .dateTime.hour().minute())
                                                .opacity(0.5)
                                                .font(.caption)
                                                .frame(width: 70)
                                        }
                                        .offset(y: 10)
                                        
                                        Button("Star reminder", systemImage:  sleepReminder.isStarred ? "star.fill" : "star"){
                                            withAnimation(.easeInOut){
                                                sleepReminder.isStarred.toggle()
                                            }
                                        }
                                        .labelStyle(.iconOnly)
                                        .imageScale(.large)
                                        .font(.system(size:20))
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(.tint)
                                        .fontWeight(.light)
                                        .opacity(0.7)
                                        .frame(maxWidth: 500, alignment: .trailing)
                                    }
                                    .padding()
                                    .frame(maxWidth: 500, alignment: .leading)
                                }
                            }
                            NavigationLink(destination: TestSleepView()){
                                Label("See all reminders", systemImage: "info.circle.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.system(size:25))
                                    .labelStyle(.iconOnly)
                                    .padding(3)
                                    .frame(maxWidth: 500, alignment: .trailing)
                            }
                            
                        }
                        .padding(.horizontal, 15)
                        .padding(.bottom, 10)
                        .background(Color.lightRose.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                        .padding()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack{
                    Text("988")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Divider()
                        .frame(maxHeight: 30)
                        .padding()
                    
                    VStack(alignment: .center, spacing: 3){
                        Image(systemName: "phone.fill")
                            .foregroundStyle(.tint)
                            .font(.system(size:30))
                            .padding(.bottom)
                        Text("Emergency help")
                    }
                }
                
            }
            
            .scrollDismissesKeyboard(.interactively)
            .animation(.easeInOut, value: sleepReminders)
        }
    }
    
    var top: some View{
        VStack {
            Text("WeTalk")
                .padding()
                .font(.system(size: 40))
                .background(.tint, in: RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
            QuoteCard()
        }
        .padding()
    }
    
    var buttons: some View{
        HStack{
            NavigationLink(destination: Journal()){
                Label("Start writing", systemImage: "pencil.circle.fill")
                    .font(.system(size:70))
                    .labelStyle(.iconOnly)
                    .foregroundColor(.accentColor)
                    .labelStyle(.iconOnly)
            }
            .padding(.horizontal, 5)
            
            NavigationLink(destination: BoxBreathingView()){
                Label("Box breathing", systemImage: "lungs.fill")
                    .font(.system(size:70))
                    .labelStyle(.iconOnly)
                    .foregroundColor(.accentColor)
                    .labelStyle(.iconOnly)
            }
            .padding(.horizontal, 5)
            
            NavigationLink(destination: TestSleepView()){
                Label("Sleep tracker", systemImage: "bed.double.circle.fill")
                    .font(.system(size:70))
                    .labelStyle(.iconOnly)
                    .foregroundColor(.accentColor)
                    .labelStyle(.iconOnly)
            }
            .padding(.horizontal, 5)
        }
    }
    
    func allStarred() -> Bool{
        for sleepReminder in sleepReminders{
            if sleepReminder.isStarred{
                return true
            }
        }
        return false
    }
}

#Preview {
    Home()
        .modelContainer(for: [SleepReminder.self, Entry.self, SleepLog.self])
}
