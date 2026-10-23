//
//  ReminderCard.swift
//  GirlTalk
//
//  Created by Maya M on 9/21/26.
//

import SwiftUI
import SwiftData

struct ReminderCard: View {
    @Query(sort: \SleepReminder.time)
    private var sleepReminders: [SleepReminder]
    @Environment(\.modelContext) private var context
    
    @State private var newReminder = ""
    @State private var newReminderTime = Date.now
    @State private var createNewReminder = false
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Sleep routine")
                    .fontWeight(.bold)
                    .frame(maxWidth: 500, alignment: .leading)
                    .font(.body.lowercaseSmallCaps())
                    .opacity(0.5)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                if (sleepReminders.isEmpty && !createNewReminder){
                    Text("No reminders yet")
                        .padding()
                        .fontWeight(.light)
                        .foregroundStyle(.gray)
                } else {
                    VStack{
                        ForEach(sleepReminders) { sleepReminder in
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
                                
                                Button("Reminder done", systemImage:  sleepReminder.isStarred ? "star.fill" : "star"){
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
                        .frame(maxWidth: 500, minHeight: 10, maxHeight: 350, alignment: .leading)
                    
                    }
                    .padding(.horizontal, 30)
                }
                
                if createNewReminder {
                    HStack{
                        Circle()
                            .stroke(lineWidth: 1.5)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.tint)
                            .fontWeight(.light)
                            .opacity(0.7)
                        
                        DatePicker(selection: $newReminderTime, displayedComponents: .hourAndMinute){
                            TextField("Reminder", text: $newReminder)
                                .onKeyPress(.return){
                                    withAnimation(.easeInOut){
                                        let newSleepReminder = SleepReminder(reminder: newReminder, time: newReminderTime, isStarred: false)
                                        context.insert(newSleepReminder)
                                        newReminder = ""
                                        newReminderTime = .now
                                        
                                        print(sleepReminders)
                                        return .handled
                                    }
                                }
                        }
                    }
                    .padding()
                    .frame(maxWidth: 500, alignment: .leading)
                    .padding(.horizontal, 30)
                }
                
                Button("Show next", systemImage: "plus.circle.fill"){
                    withAnimation(.easeInOut){
                        createNewReminder.toggle()
                    }
                }
                .labelStyle(.iconOnly)
                .font(.system(size:25))
                .foregroundStyle(.tint)
                .offset(x: 150)
                .animation(.easeInOut, value: createNewReminder)
                
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 10)
            .background(Color.lightRose.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
            .padding()
        }
        .animation(.easeInOut, value: sleepReminders)
    }
}


#Preview {
    ReminderCard()
        .modelContainer(for: SleepReminder.self)
}
