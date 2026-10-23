//
//  SleepView.swift
//  GirlTalk
//
//  Created by Maya M on 8/25/26.
//

import SwiftUI
import SwiftData

struct TestSleepView: View {
    var body: some View {
        ScrollView {
            Text("Sleep Log")
                .padding()
                .font(.system(size: 40))
                .background(.tint, in: RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
                .padding(.bottom, 30)
            
            TimeSlept()
            ReminderCard()
        }
    }
}


#Preview {
    TestSleepView()
        .modelContainer(for: [SleepReminder.self, SleepLog.self])
}
