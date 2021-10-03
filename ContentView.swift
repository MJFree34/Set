//
//  ContentView.swift
//  Set
//
//  Created by Matt Free on 8/21/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: StandardSetGame
    
    var body: some View {
        VStack {
            Text("SCORE: \(game.score)")
                .font(.headline)
                .fontWeight(.bold)
            
            AspectVGrid(items: game.dealtCards, aspectRatio: 2/3) { card in
                if card.isMatched {
                    Rectangle()
                        .opacity(0)
                } else {
                    CardView(card: card)
                        .padding(2)
                        .onTapGesture {
                            game.choose(card)
                        }
                }
            }
            .foregroundColor(.black)
            
            HStack {
                Button("New Game") {
                    game.newGame()
                }
                
                Spacer()
                
                Button("Cheat") {
                    game.cheat()
                }
                
                Spacer()
                
                Button("Deal") {
                    game.dealCards()
                }
                .disabled(game.allCardsDealt)
            }
            .font(.title3)
            .buttonStyle(.bordered)
            .padding(.horizontal, 2)
        }
        .padding([.horizontal, .top])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: StandardSetGame())
    }
}
