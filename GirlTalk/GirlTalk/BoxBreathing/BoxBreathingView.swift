//
//  BoxBreathingView.swift
//  GirlTalk
//
//  Created by Maya M on 8/15/26.
//

import SwiftUI
internal import Combine

enum EaseBreathe: CaseIterable{
    case idle, breatheIn, holdIn, breatheOut, holdOut, done
}

struct BoxBreathingView: View {
    @State private var countTimer = 4
    @State private var runTimer = false
    @State private var step = "Begin!"
    @State private var text = "Begin box breathing"
    @State private var completed = 0
    @State private var boxBreathe = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView{
            Text("Breathe")
                .padding()
                .font(.system(size: 40))
                .background(.tint, in: RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
            
            VStack{
                PhaseAnimator(boxBreathe ? EaseBreathe.allCases : [.idle], trigger: boxBreathe){
                    phase in
                    Text("_\(text)_")
                        .font(.title2)
                        .padding()
                        .offset(y: 30)
                        .padding(.bottom, 30)
                    
                    ZStack{
                        Text("\(countTimer)")
                            .onReceive(timer) { _ in
                                if (runTimer) {
                                    if (countTimer > 1) {
                                        withAnimation{
                                            countTimer -= 1
                                        }
                                    } else {
                                        withAnimation{
                                            countTimer = 4
                                        }
                                    }
                                } else {
                                    runTimer = false
                                    countTimer = 4
                                }
                            }
                            .font(.system(size:70))
                            .fontWeight(.bold)
                            .font(.title)
                            .contentTransition(.numericText())
                            .padding(.top, 75)
                            .padding(.bottom, 55)
                        
                        Circle()
                            .stroke(lineWidth: 15)
                            .font(.system(size: 150))
                            .foregroundColor(phase == .idle ? .purple : phase == .breatheIn || phase == .holdIn ? .yellow : phase == .breatheOut || phase == .holdOut ? .green : .purple)
                        
                            .scaleEffect(phase == .idle ? 1.25 : phase == .breatheIn ? 1.5 : phase == .holdIn ? 1.75 : phase == .holdOut ? 1.25 : phase == .breatheOut ? 1.5 : 1.25)
                            .frame(maxWidth: 130)
                            .padding(.top, 75)
                            .padding(.bottom, 55)
                            .frame(maxWidth: 350)
                        
                            .onChange(of: phase){ _, phase in
                                runTimer = true
                                countTimer = 4
                                withAnimation(.spring(duration: 0.5)){
                                    switch phase {
                                    case .idle: text = "Begin box breathing"; runTimer = false
                                    case .breatheIn: text = "Breathe in"
                                    case .holdIn, .holdOut: text = "Hold"
                                    case .breatheOut: text = "Breathe out"
                                    case .done: completed += 1; boxBreathe = false
                                    }
                                }
                            }
                    }
                    
                } animation: { phase in
                        switch phase {
                        case .idle: .easeIn(duration: 0.5)
                        case .breatheIn, .holdIn : .linear(duration: 4)
                        case .breatheOut, .holdOut : .linear(duration: 4)
                        case .done : .easeOut(duration: 0.5)
                    }
                }
                
                Button("Box breathe", systemImage: boxBreathe ? "pause.circle.fill" :"play.circle.fill"){
                    boxBreathe = !boxBreathe
                    runTimer = !runTimer
                }
                .font(.system(size:70))
                .labelStyle(.iconOnly)
                .padding()
                
                Divider()
                
                Text("Completed:")
                    .padding(.top, 40)
                    .font(.system(size: 25))
                    .foregroundStyle(.black)
                
                Text("\(completed)")
                    .padding(3)
                    .font(.system(size: 40))
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                    .contentTransition(.numericText())
            }
        }
    }
}


#Preview {
    BoxBreathingView()
}
