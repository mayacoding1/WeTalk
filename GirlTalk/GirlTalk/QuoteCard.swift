//
//  QuoteCard.swift
//  GirlTalk
//
//  Created by Maya M on 7/12/26.
//

import SwiftUI
struct QuoteCard: View{
    @State private var quotes: [String] = ["\"Being a healthy woman isn’t about getting on a scale or measuring your waistline\"", "\"The human body is the best picture of the human soul.\"", "\"To be beautiful means to be yourself. You don’t need to be accepted by others. You need to accept yourself.\"", "\"The best gift you are ever going to give someone — the permission to feel safe in their own skin.\"", "\"And I said to my body, softly, ‘I want to be your friend.'...\"", "\"This body had carried me through a hard life. It looked exactly the way it was supposed to.\""]
    
    @State private var pickedQuote = "\"And I said to my body, softly, ‘I want to be your friend.'...\""
    
    var body: some View{
        HStack{
            Text("\(pickedQuote)")
                .padding()
                .font(.system(size: 20))
                .foregroundStyle(.black)

            
            Button("Pick random quote", systemImage: "arrow.clockwise.circle.fill") {
                withAnimation{
                    if let randomQuote = quotes.randomElement(){
                        pickedQuote = randomQuote
                    } else {
                        pickedQuote = "\"And I said to my body, softly, ‘I want to be your friend.'...\""
                    }
                }
            }
            .padding()
            .labelStyle(.iconOnly)
            .font(.system(size: 40))
        }

        .background(.lightRose.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
        .padding()
        
    }
}
